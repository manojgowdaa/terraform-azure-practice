module "create_resource_group" {
  source = "./modules/create_resource_group"
  
  resource_group_name = var.resource_group_name
  location            = var.azure_location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  subnet_name         = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix
}

module "create_storage_account" {
  source = "./modules/create_storage_account"
  
  resource_group_name = module.create_resource_group.resource_group_name
  location            = var.azure_location
  storage_account_name = var.storage_account_name
  
  depends_on = [module.create_resource_group]
}

module "create_virtual_machine" {
  source = "./modules/create_ec2"
  
  resource_group_name   = module.create_resource_group.resource_group_name
  location              = var.azure_location
  vm_name               = var.vm_name
  vm_size               = var.vm_size
  subnet_id             = module.create_resource_group.subnet_id
  vm_admin_username     = var.vm_admin_username
  
  depends_on = [module.create_resource_group]
}