variable "resource_group_name" {
  description = "The name of the Azure Resource Group"
  type        = string
  default     = "gmt-prod-eus-rg"
}

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
  default     = "West US"
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
  default     = "ChinguContainerRegistry"
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
  default     = "ChinguAppServicePlan"
}

variable "app_service_name" {
  description = "The name of the App Service"
  type        = string
  default     = "ChinguBackendAppService"
}

variable "docker_image_name" {
  description = "The name of the Docker image in the ACR."
  type        = string
  # This should match what you used in the GitHub Action, e.g., "webapp/chinguimage"
  default = "webapp/chinguimage"
}

variable "docker_image_tag" {
  description = "The tag of the Docker image."
  type        = string
  default     = "latest"
}
