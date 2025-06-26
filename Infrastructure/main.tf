# This data source retrieves the client configuration for the provider.
# It's the correct way to access details like the current subscription and tenant ID.
data "azurerm_client_config" "current" {}

# Create a resource group to contain all the resources for the App Service.
resource "azurerm_resource_group" "rg" {
  name     = "appservice-rg"
  location = "East US" # You can change this to your preferred Azure region.
}

# Create an App Service Plan, which defines the underlying hardware for the App Service.
# The "F1" SKU is a free tier, suitable for testing and development.
resource "azurerm_service_plan" "plan" {
  name                = "appservice-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1" # Free tier SKU
}

# Create the App Service itself.
# This example is configured for a Node.js application.
resource "azurerm_linux_web_app" "app" {
  name                = "my-unique-app-name-12345" # <-- IMPORTANT: This name must be globally unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}

# This output generates the JSON object that you will use as a secret in GitHub.
# The subscriptionId and tenantId are automatically populated by the data source.
# The clientId and clientSecret should be populated manually from the output of the
# 'az ad sp create-for-rbac' command you will run after applying this Terraform configuration.
output "github_actions_secret" {
  value = jsonencode({
    clientId               = ""
    clientSecret           = ""
    subscriptionId         = data.azurerm_client_config.current.subscription_id
    tenantId               = data.azurerm_client_config.current.tenant_id
    activeDirectoryEndpointUrl = "https://login.microsoftonline.com"
    resourceManagerEndpointUrl = "https://management.azure.com/"
    sqlManagementEndpointUrl   = "https://management.core.windows.net:8443/"
    galleryEndpointUrl         = "https://gallery.azure.com/"
    managementEndpointUrl      = "https://management.core.windows.net/"
  })
  description = "The JSON object to be used as a secret for GitHub Actions."
}
