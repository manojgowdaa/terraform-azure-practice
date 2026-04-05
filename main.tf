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

module "create_container_registry" {
  source = "./modules/create_container_registry"

  acr_name            = var.acr_name
  resource_group_name = module.create_resource_group.resource_group_name
  location            = var.azure_location

  depends_on = [module.create_resource_group]
}

module "create_app_service" {
  source = "./modules/create_app_service"

  app_service_plan_name = var.app_service_plan_name
  app_name_prefix       = var.app_name_prefix
  resource_group_name   = module.create_resource_group.resource_group_name
  location              = var.azure_location
  app_count             = var.app_count
  docker_image          = var.docker_image
  docker_registry_url   = var.docker_registry_url

  depends_on = [module.create_resource_group]
}

module "create_sql_database" {
  source = "./modules/create_sql_database"

  resource_group_name = module.create_resource_group.resource_group_name
  location            = var.azure_location
  sql_server_name     = var.sql_server_name
  admin_username      = var.sql_admin_username
  admin_password      = var.sql_admin_password
  database_name       = var.database_name

  depends_on = [module.create_resource_group]
}

#module "create_virtual_machine" {
#  source = "./modules/create_virtual_machine"
  
#  resource_group_name   = module.create_resource_group.resource_group_name
#  location              = var.azure_location
#  vm_name               = var.vm_name
#  vm_size               = var.vm_size
#  subnet_id             = module.create_resource_group.subnet_id
#  vm_admin_username     = var.vm_admin_username
  
#  depends_on = [module.create_resource_group]
#}
