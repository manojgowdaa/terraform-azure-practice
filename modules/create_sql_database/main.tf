resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  tags = {
    Name = var.sql_server_name
  }

  lifecycle {
    ignore_changes = [public_network_access_enabled, outbound_network_restriction_enabled]
  }
}

resource "azurerm_mssql_firewall_rule" "sql_firewall_rule" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"

  lifecycle {
    ignore_changes = [start_ip_address, end_ip_address]
  }
}

resource "azurerm_mssql_database" "sql_database" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.sql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"

  tags = {
    Name = var.database_name
  }
}
