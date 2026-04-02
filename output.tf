output "resource_group_name" {
  description = "Name of the created Resource Group"
  value       = module.create_resource_group.resource_group_name
}

output "resource_group_id" {
  description = "ID of the created Resource Group"
  value       = module.create_resource_group.resource_group_id
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.create_resource_group.vnet_id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = module.create_resource_group.subnet_id
}

output "vm_public_ip" {
  description = "Public IP address of the Azure VM"
  value       = module.create_virtual_machine.public_ip_address
}

output "vm_id" {
  description = "ID of the Azure Virtual Machine"
  value       = module.create_virtual_machine.vm_id
}

output "storage_account_name" {
  description = "Name of the Storage Account for Terraform state"
  value       = module.create_storage_account.storage_account_name
}

output "terraform_state_container" {
  description = "Container name for Terraform state"
  value       = module.create_storage_account.container_name
}

output "ssh_private_key" {
  description = "SSH private key for accessing the Virtual Machine"
  value       = module.create_virtual_machine.ssh_private_key
  sensitive   = true
}
