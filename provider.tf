terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = "1464e5df-c763-4ee2-a66f-ba60fb01ebc7"
  client_secret   = "f5be1678-cac3-4afd-9667-e95866ac5b39"
  tenant_id       = "var.azure_tenant_id"
}

provider "tls" {
  # TLS provider for SSH key generation
}
