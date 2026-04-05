variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region/location for the SQL server"
  type        = string
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for SQL Server"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Administrator password for SQL Server"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Name of the SQL Database"
  type        = string
}
