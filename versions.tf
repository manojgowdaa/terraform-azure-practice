terraform {
  required_version = ">= 1.0"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-test-2026"
    storage_account_name = "storageacct9876543"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
