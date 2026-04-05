variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_client_id" {
  description = "Azure Client ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_client_secret" {
  description = "Azure Client Secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-test"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "vnet-main"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet-main"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
  default     = "storageaccttest"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "acrtest"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "asp-linux"
}

variable "app_name_prefix" {
  description = "Prefix for the Linux Web App names"
  type        = string
  default     = "webapp-linux"
}

variable "app_count" {
  description = "Number of Linux Web App instances to create"
  type        = number
  default     = 1
}

variable "docker_image" {
  description = "Docker image and tag for the container"
  type        = string
  default     = "nginx:latest"
}

variable "docker_registry_url" {
  description = "URL of the container registry"
  type        = string
  default     = "https://index.docker.io"
}

variable "vm_name" {
  description = "Name of the Azure Virtual Machine"
  type        = string
  default     = "vm-ubuntu"
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B1s"
}

variable "vm_admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = string
  default     = "azureuser"
}

variable "sql_server_name" {
  description = "Name of the Azure SQL Server"
  type        = string
  default     = "sqlserver-main"
}

variable "sql_admin_username" {
  description = "Administrator username for SQL Server"
  type        = string
  sensitive   = true
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "Administrator password for SQL Server"
  type        = string
  sensitive   = true
  default     = ""
}

variable "database_name" {
  description = "Name of the Azure SQL Database"
  type        = string
  default     = "sqldb-main"
}
