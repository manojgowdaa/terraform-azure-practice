resource "azurerm_storage_account" "sa_terraform_state" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  https_traffic_only_enabled = true

  tags = {
    Name = var.storage_account_name
    Purpose = "Terraform State Storage"
  }
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa_terraform_state.name
  container_access_type = "private"
}

resource "azurerm_storage_account_blob_properties" "sa_blob_props" {
  storage_account_id = azurerm_storage_account.sa_terraform_state.id

  delete_retention_policy {
    days = 7
  }

  versioning_enabled = true
}
create_virtual_machine