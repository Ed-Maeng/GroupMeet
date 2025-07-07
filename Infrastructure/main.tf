# --- Resource Group ---
# A resource group is a container that holds related resources for an Azure solution.
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# --- Azure Container Registry (ACR) ---
# Used to store and manage your private Docker container images.
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard" # Choose between Basic, Standard, and Premium
  admin_enabled       = true       # Enable admin user for easy login/password access
}

#--- App Service Plan ---
#Defines the underlying compute resources (VM size and scale) for your App Service.
resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux" # Required for Docker containers
  sku_name            = "P1v3"  # Choose a pricing tier that fits your needs
}

# --- App Service ---
# The main resource for hosting your web application.
resource "azurerm_linux_web_app" "app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  # Site configuration
  site_config {
    # This setting configures the app to use a container image.
    always_on = true # Keeps the app running, avoiding cold starts on some plans.

    # Tells App Service where to get the Docker image.
    # We are using the login server, username, and password from the ACR created above.
    # The image name and tag need to be updated after you push your image.
    application_stack {
      docker_image_name   = "${var.docker_image_name}:${var.docker_image_tag}"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  # App Settings
  # Use these to pass environment variables to your application.
  # The WEBSITES_PORT variable tells App Service which port your container is listening on.
  app_settings = {
    "WEBSITES_PORT"  = "8080" # Make sure this matches the port in your Dockerfile and Go app


  }

  # Identity configuration (optional but recommended)
  # A system-assigned managed identity can be used to securely access other Azure resources (like ACR).
  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_container_registry.acr,
    azurerm_service_plan.plan,
  ]

  tags = {
    environment = "development"
  }
}

# --- Role Assignment for ACR Pull ---
# Grants the App Service's managed identity the permission to pull images from the ACR.
# This is more secure than using admin credentials in app settings.
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}

# Storage for Images
resource "azurerm_storage_account" "chinggustorageacct" {
  name                     = "chingustorageacct"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "chinggustoragecontainer" {
  name                  = "images"
  storage_account_id    = azurerm_storage_account.chinggustorageacct.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "profile-images"
  storage_account_name   = azurerm_storage_account.chinggustorageacct.name
  storage_container_name = azurerm_storage_container.chinggustoragecontainer.name
  type                   = "Block"
}