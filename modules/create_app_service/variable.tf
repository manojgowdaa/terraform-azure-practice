variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "app_name_prefix" {
  description = "Prefix for the Linux Web App names"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region/location"
  type        = string
}

variable "app_count" {
  description = "Number of Linux Web App instances to create"
  type        = number
  default     = 1
}

variable "docker_image" {
  description = "Docker image and tag for the container (e.g. 'nginx:latest')"
  type        = string
  default     = "nginx:latest"
}

variable "docker_registry_url" {
  description = "URL of the container registry"
  type        = string
  default     = "https://index.docker.io"
}
