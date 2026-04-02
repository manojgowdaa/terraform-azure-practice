# Terraform Azure Infrastructure

This Terraform configuration deploys infrastructure on Microsoft Azure following the repository's modular structure.

## Architecture Overview

The configuration creates:
- **Resource Group**: `rg-test` (all resources deployed within this RG)
- **Virtual Network (VNet)**: `vnet-main` with a subnet for all resources
- **Virtual Machine**: Ubuntu-based Azure VM running within the VNet
- **Storage Account**: For Terraform state management (backend)
- **Network Security Group**: For VM security with SSH access rules

## Prerequisites

1. **Azure Account** with an active subscription ("Azure subscription 1")
2. **Azure CLI** installed and configured
3. **Terraform** version >= 1.0
4. **Credentials** from your Azure Service Principal:
   - Application (Client) ID: `1464e5df-c763-4ee2-a66f-ba60fb01ebc7`
   - Client Secret: `f5be1678-cac3-4afd-9667-e95866ac5b39`
   - Tenant ID: (retrieve from Azure Portal)
   - Subscription ID: (retrieve from Azure Portal)

## Setup Instructions

### Step 1: Get Your Azure Credentials

1. Log in to Azure Portal (https://portal.azure.com)
2. Navigate to **Azure Active Directory > Properties**
   - Copy your **Tenant ID**
3. Navigate to **Subscriptions**
   - Find "Azure subscription 1" and copy the **Subscription ID**

### Step 2: Configure Terraform Variables

1. Copy the example file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your Azure credentials:
   ```hcl
   azure_tenant_id       = "YOUR_TENANT_ID"
   azure_subscription_id = "YOUR_SUBSCRIPTION_ID"
   ```

3. **IMPORTANT**: Add `terraform.tfvars` to `.gitignore` to protect credentials:
   ```bash
   echo "terraform.tfvars" >> .gitignore
   ```

### Step 3: Initialize Terraform

**First Time Setup** (without backend state):
```bash
terraform init -backend=false
```

This initializes Terraform without the remote backend since the backend storage doesn't exist yet.

### Step 4: Create Backend Infrastructure (Optional)

If you want to use remote state storage (recommended), you need to manually create the storage account first:

```bash
az storage account create \
  --name tfstatestorageaccount \
  --resource-group rg-terraform-state \
  --location eastus \
  --sku Standard_LRS

az storage container create \
  --name tfstate \
  --account-name tfstatestorageaccount
```

Then reconfigure Terraform to use the backend:
```bash
terraform init
```

### Step 5: Validate Configuration

```bash
terraform plan
```

### Step 6: Deploy Infrastructure

```bash
terraform apply
```

When prompted, review the changes and type `yes` to confirm.

## Module Structure

```
.
├── main.tf              # Root module - calls all child modules
├── provider.tf          # Azure provider configuration
├── versions.tf          # Terraform version and backend config
├── variable.tf          # Root module variables
├── output.tf            # Root module outputs
├── terraform.tfvars     # Variable values (KEEP SECRET - don't commit)
│
└── modules/
    ├── create_resource_group/   # Creates RG, VNet, Subnet, NSG
    │   ├── main.tf
    │   ├── variable.tf
    │   └── output.tf
    ├── create_ec2/              # Creates Azure VM (renamed from AWS)
    │   ├── main.tf
    │   ├── variable.tf
    │   └── output.tf
    └── create_s3/               # Creates Storage Account (renamed from AWS)
        ├── main.tf
        ├── variable.tf
        └── output.tf
```

## Key Outputs

After successful deployment, Terraform will output:
- **Resource Group Name**: `rg-test`
- **Virtual Network ID**: VNet identifier
- **VM Public IP**: For SSH access to the virtual machine
- **Storage Account Name**: For state management
- **SSH Private Key**: Auto-generated for VM access (stored securely in Terraform state)

## Accessing the Virtual Machine

```bash
# Get the public IP from Terraform outputs
terraform output vm_public_ip

# Get the SSH private key
terraform output -raw ssh_private_key > vm_key.pem
chmod 600 vm_key.pem

# SSH into the VM
ssh -i vm_key.pem azureuser@<vm_public_ip>
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

When prompted, type `yes` to confirm deletion.

## Security Best Practices Implemented

1. **SSH Key Pair Generation**: Automatically generated using RSA-4096
2. **HTTPS Only**: Storage account configured for HTTPS-only traffic
3. **Network Isolation**: VM deployed within a VNet with NSG rules
4. **State Encryption**: Terraform state stored with versioning enabled
5. **Private Access**: Storage container set to private access level
6. **No Public Exposure**: Default NSG blocks inbound traffic except SSH

## Troubleshooting

### Authentication Failed
- Verify credentials in `terraform.tfvars`
- Check Tenant ID and Subscription ID are correct
- Ensure service principal has permission in the subscription

### Storage Account Name Conflict
- Storage account names must be **globally unique**
- Update `storage_account_name` in `terraform.tfvars` with a unique name (lowercase alphanumeric only)

### Backend Not Found
- First deployment should use `-backend=false` flag
- Create backend infrastructure manually before re-initializing with backend

### VM Connection Issues
- Verify NSG rules allow SSH (port 22)
- Check your client IP isn't blocked
- Ensure the SSH private key file has correct permissions (600)

## Documentation References

- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Terraform Backend](https://www.terraform.io/cloud-docs/state/remote-state-azure)
- [Azure Virtual Networks](https://learn.microsoft.com/en-us/azure/virtual-network/)

## Cost Considerations

This configuration uses cost-effective resources:
- **Standard_B1s VM**: ~$10-15/month
- **Storage Account (LRS)**: ~$1-2/month
- **Total Estimated**: ~$15-20/month (Azure credits apply)

Monitor costs in Azure Portal > Cost Management + Billing.
