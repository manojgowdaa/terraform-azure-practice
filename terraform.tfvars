# Azure Tenant ID - Replace with your actual Tenant ID
# You can find this in Azure Portal > Azure Active Directory > Properties
#azure_tenant_id = "YOUR_TENANT_ID_HERE"

# Azure subscription ID 
# Replace with your actual subscription ID from "Azure subscription 1"
# Found in Azure Portal > Subscriptions
#azure_subscription_id = "YOUR_SUBSCRIPTION_ID_HERE"

# Azure region/location
azure_location = "East US"

# Resource Group
resource_group_name = "rg-test"

# Virtual Network and Subnet
vnet_name              = "vnet-main"
vnet_address_space     = ["10.0.0.0/22"]
subnet_name            = "subnet-main"
subnet_address_prefix  = ["10.0.1.0/24"]

# Storage Account (must be unique globally, use lowercase alphanumeric only)
storage_account_name = "storageaccttest"

# Virtual Machine
vm_name           = "vm-ubuntu"
vm_size           = "Standard_B1s"
vm_admin_username = "azureuser"
