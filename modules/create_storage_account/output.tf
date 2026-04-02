output "storage_account_id" {
  description = "ID of the Azure Storage Account"
  value       = azurerm_storage_account.sa_terraform_state.id
}

output "storage_account_name" {
  description = "Name of the Azure Storage Account"
  value       = azurerm_storage_account.sa_terraform_state.name
}

output "container_name" {
  description = "Name of the container for Terraform state"
  value       = azurerm_storage_container.tfstate_container.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL"
  value       = azurerm_storage_account.sa_terraform_state.primary_blob_endpoint
}
