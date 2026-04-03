output "service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.app_plan.id
}

output "app_names" {
  description = "Names of the Linux Web Apps"
  value       = azurerm_linux_web_app.app[*].name
}

output "app_default_hostnames" {
  description = "Default hostnames of the Linux Web Apps"
  value       = azurerm_linux_web_app.app[*].default_hostname
}
