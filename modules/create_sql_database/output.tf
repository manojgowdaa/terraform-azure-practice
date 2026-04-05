output "sql_server_id" {
  description = "ID of the created SQL Server"
  value       = azurerm_mssql_server.sql_server.id
}

output "sql_server_name" {
  description = "Name of the created SQL Server"
  value       = azurerm_mssql_server.sql_server.name
}

output "sql_server_fqdn" {
  description = "Fully Qualified Domain Name of the SQL Server"
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "database_id" {
  description = "ID of the created SQL Database"
  value       = azurerm_mssql_database.sql_database.id
}

output "database_name" {
  description = "Name of the created SQL Database"
  value       = azurerm_mssql_database.sql_database.name
}
