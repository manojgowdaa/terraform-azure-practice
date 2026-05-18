# Azure Tenant ID - Replace with your actual Tenant ID
# You can find this in Azure Portal > Azure Active Directory > Properties
azure_tenant_id = "d677716a-4e46-4004-aa41-47f616f055cf"

# Azure subscription ID 
# Replace with your actual subscription ID from "Azure subscription 1"
# Found in Azure Portal > Subscriptions
azure_subscription_id = "066f974e-d4a4-4583-9a93-20adb9dcb37b"

# Azure region/location
azure_location = "Canada Central"

# Resource Group
resource_group_name = "rg-terraform-test-2026"

# Virtual Network and Subnet
vnet_name              = "vnet-main"
vnet_address_space     = ["10.0.0.0/22"]
subnet_name            = "subnet-main"
subnet_address_prefix  = ["10.0.1.0/24"]

# Storage Account (must be unique globally, use lowercase alphanumeric only)
# Change this to a unique name - e.g., storageacct1234567890
storage_account_name = "storageacct98765432"

# Azure Container Registry (must be globally unique, alphanumeric only)
acr_name = "acrterraform2026vk"

# App Service (Linux Web App with container)
app_service_plan_name = "asp-linux-terraform-2026"
app_name_prefix       = "webapp-linux-tf2026-vk"
app_count             = 1
docker_image          = "nginx:latest"
docker_registry_url   = "https://index.docker.io"

# Virtual Machine
vm_name           = "vm-ubuntu"
vm_size           = "Standard_D2s_v3"
vm_admin_username = "azureuser"

# SQL Database
sql_server_name     = "sqlserver-tf-2026-vk"
sql_admin_username  = "sqladmin"
sql_admin_password  = "P@ssw0rd1234!"
database_name       = "sqldb-terraform-2026"
