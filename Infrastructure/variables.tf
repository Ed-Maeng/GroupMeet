variable "resource_group_name" {
    description = "The name of the Azure Resource Group"
    type        = string
    default = "gmt-prod-eus-rg"
}

variable "location" {
    description = "The Azure region where resources will be deployed"
    type        = string
    default     = "West US"
}

variable "acr_name" {
    description = "The name of the Azure Container Registry"
    type        = string
    default = "ChinguContainerRegistry"
}
