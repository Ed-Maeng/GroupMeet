# Terraform Azure App Service & GitHub Actions Setup

This Terraform configuration automates the deployment of a Linux-based Azure App Service and all its necessary components. It is designed to work with a GitHub Actions workflow for continuous integration and continuous deployment (CI/CD).

## What This Terraform Code Does

This configuration will create the following resources in your Azure account:

1.  **Resource Group (`azurerm_resource_group`):** A logical container to hold all the related Azure resources for this project.
2.  **App Service Plan (`azurerm_service_plan`):** Defines the underlying compute resources (VM size, OS) that will run your application. This configuration uses the **F1 Free Tier**, which is suitable for development and testing.
3.  **App Service (`azurerm_linux_web_app`):** The web application service itself, configured to run a Node.js application.
4.  **Client Config Data Source (`data.azurerm_client_config`):** A helper that retrieves information about the current Azure session, such as your Subscription ID and Tenant ID.
5.  **GitHub Actions Secret Output:** An output that generates a JSON template. You will populate this template with credentials to securely connect your GitHub Actions workflow to Azure.

---

## Prerequisites

Before you can use this Terraform code, you must install the following tools on your local machine:

* **Terraform:** [Download and install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* **Azure CLI:** [Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

---

## Setup and Configuration Steps

Follow these steps to configure your environment before running the Terraform commands.

### 1. Log in to Azure

Open your terminal or command prompt and log in to your Azure account using the Azure CLI:

```bash
az login
```
This will open a browser window for you to complete the authentication process.

### 2. Configure the ```main.tf``` File

There are two important values you must update in the ```main.tf``` file:

#### A. Set Your Subscription ID

First, find your Azure Subscription ID by running:

```bash
az account show
```
Copy the ```id``` value from the JSON output. Then, open ```main.tf``` and find the ```provider "azurerm"``` block. Replace the placeholder with your actual Subscription ID:

```hcl
provider "azurerm" {
  features {}

  # Replace the placeholder below with your actual Subscription ID
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

#### B. Choose a Unique App Service Name

The App Service name must be globally unique across all of Azure because it becomes part of a public DNS name (```your-unique-name.azurewebsites.net```).

Find the ```azurerm_linux_web_app``` resource block and change the ```name``` attribute to something unique:

```hcl
resource "azurerm_linux_web_app" "app" {
  # Change the name below to something globally unique
  name                = "my-very-unique-app-name-and-date"
  # ... other settings
}
```

## How to Run

Once you have completed the setup, you can run the standard Terraform workflow from your terminal in the same directory as the main.tf file.
### 1. Initialize Terraform

This command downloads the necessary Azure provider plugins:
```hcl
terraform init
```
### 2. Plan the Deployment

This command shows you an execution plan of what resources Terraform will create, change, or destroy:
```hcl
terraform plan
```
### 3. Apply the Configuration

This command will build the infrastructure in your Azure account:
```hcl
terraform apply
```
Terraform will ask for confirmation before proceeding. Type ```yes``` and press Enter.

After the deployment is complete, you will see the ```github_actions_secret``` output in your terminal. You will need this for the next phase of setting up your CI/CD pipeline.
## Cleaning Up

When you are finished with the resources and want to remove them from your Azure account to avoid incurring costs, run:
```hcl
terraform destroy
```
Terraform will show you all the resources that will be deleted and ask for confirmation. Type yes to proceed.