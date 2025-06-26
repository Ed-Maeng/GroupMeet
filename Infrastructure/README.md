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