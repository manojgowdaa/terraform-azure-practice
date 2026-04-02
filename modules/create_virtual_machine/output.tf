output "vm_id" {
  description = "ID of the Azure Virtual Machine"
  value       = azurerm_virtual_machine.vm_ubuntu[0].id
}

output "vm_name" {
  description = "Name of the Azure Virtual Machine"
  value       = azurerm_virtual_machine.vm_ubuntu[0].name
}

output "public_ip_address" {
  description = "Public IP address of the Virtual Machine"
  value       = azurerm_public_ip.pip_main.ip_address
}

output "ssh_private_key" {
  description = "SSH private key for accessing the Virtual Machine"
  value       = tls_private_key.vm_ssh.private_key_pem
  sensitive   = true
}
