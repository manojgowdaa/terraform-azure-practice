resource "azurerm_resource_group" "rg_main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Name        = var.resource_group_name
    Environment = "test"
  }
}

resource "azurerm_virtual_network" "vnet_main" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg_main.location
  resource_group_name = azurerm_resource_group.rg_main.name
  address_space       = var.vnet_address_space

  tags = {
    Name = var.vnet_name
  }
}

resource "azurerm_subnet" "subnet_main" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg_main.name
  virtual_network_name = azurerm_virtual_network.vnet_main.name
  address_prefixes     = var.subnet_address_prefix
}

resource "azurerm_network_security_group" "nsg_main" {
  name                = "nsg-main"
  location            = azurerm_resource_group.rg_main.location
  resource_group_name = azurerm_resource_group.rg_main.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name = "nsg-main"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet_main.id
  network_security_group_id = azurerm_network_security_group.nsg_main.id
}
