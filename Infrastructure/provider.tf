terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  
  subscription_id = "6c3d24a5-0ddb-4773-9c17-f6d0f84e5b8a" # <-- IMPORTANT: Replace with your Azure subscription ID
}
