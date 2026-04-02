# Azure Terraform Implementation Guide

## Project Summary

This Terraform project has been successfully converted from AWS to Azure infrastructure while maintaining the existing repository structure. All resources are deployed within a single Resource Group (`rg-test`) and Virtual Network (`vnet-main`).

## 🎯 Deployment Architecture

```
Azure Subscription
│
└── Resource Group: rg-test
    │
    ├── Virtual Network: vnet-main (10.0.0.0/16)
    │   │
    │   ├── Subnet: subnet-main (10.0.1.0/24)
    │   │   │
    │   │   ├── Azure Virtual Machine (Ubuntu)
    │   │   │   ├── Network Interface
    │   │   │   ├── Public IP
    │   │   │   └── SSH Key Pair
    │   │   │
    │   │   └── Network Security Group
    │   │       └── Inbound SSH Rule (Port 22)
    │   │
    │   └── Route Tables (if needed)
    │
    ├── Storage Account: storageaccttest
    │   ├── Blob Service Properties
    │   │   ├── Versioning: Enabled
    │   │   └── Delete Retention: 7 days
    │   │
    │   └── Container: tfstate
    │       └── Terraform State Files
    │
    └── Resource Group: rg-terraform-state (backend)
        └── Storage Account: tfstatestorageaccount
            └── Container: tfstate
```

## 📁 Repository Structure

### Root Configuration Files
| File | Purpose |
|------|---------|
| `provider.tf` | Azure provider configuration with service principal auth |
| `versions.tf` | Terraform version requirements and Azure Storage backend config |
| `variable.tf` | Root-level input variables for the entire deployment |
| `output.tf` | Root-level outputs (IP addresses, IDs, etc.) |
| `main.tf` | Module composition - calls all child modules |

### Modules
```
modules/
├── create_resource_group/  ← NEW MODULE
│   ├── main.tf            (RG, VNet, Subnet, NSG)
│   ├── variable.tf
│   └── output.tf
│
├── create_ec2/            ← CONVERTED from AWS EC2
│   ├── main.tf            (Azure VM, NIC, Public IP, SSH Key)
│   ├── variable.tf
│   └── output.tf
│
└── create_s3/             ← CONVERTED from AWS S3
    ├── main.tf            (Storage Account, Container, Versioning)
    ├── variable.tf
    └── output.tf
```

### Supporting Files
| File | Purpose |
|------|---------|
| `AZURE_SETUP_README.md` | Complete setup and troubleshooting guide |
| `terraform.tfvars.example` | Template for required variables |
| `bootstrap-backend.sh` | Bash script to create backend infrastructure |
| `bootstrap-backend.ps1` | PowerShell script to create backend infrastructure |

## 🔄 Migration Details

### Provider Configuration
**Before (AWS):**
```terraform
provider "aws" {
  region = "us-east-2"
  # Static credentials
}
```

**After (Azure):**
```terraform
provider "azurerm" {
  subscription_id = var.azure_subscription_id
  client_id       = "1464e5df-c763-4ee2-a66f-ba60fb01ebc7"
  client_secret   = "f5be1678-cac3-4afd-9667-e95866ac5b39"
  tenant_id       = var.azure_tenant_id
}
```

### Backend Configuration
**Before (S3 with DynamoDB locking):**
```terraform
backend "s3" {
  bucket           = "manvenug321"
  region           = "us-east-2"
  dynamodb_table   = "mydynamoDB_lockingtable"
  encrypt          = true
}
```

**After (Azure Storage Account - no separate locking needed):**
```terraform
backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "tfstatestorageaccount"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
}
```

### Compute Resource Migration
**Before (AWS EC2):**
```terraform
resource "aws_instance" "ec2_ubuntu" {
  ami           = "ami-07062e2a343acc423"
  instance_type = "t3.micro"
  count         = 1
}
```

**After (Azure VM):**
```terraform
resource "azurerm_virtual_machine" "vm_ubuntu" {
  name     = "vm-ubuntu"
  vm_size  = "Standard_B1s"  # Comparable to t3.micro
  count    = 1
  
  os_profile_linux_config {
    ssh_keys {
      # Auto-generated SSH key pair
    }
  }
}
```

### Storage Migration
**Before (AWS S3 only):**
```terraform
resource "aws_s3_bucket" "remotestate_s3" {
  bucket = "manvenug321"
}
```

**After (Azure Storage Account):**
```terraform
resource "azurerm_storage_account" "sa_terraform_state" {
  name                     = "storageaccttest"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  https_traffic_only_enabled = true
}
```

### Removed Components
- **DynamoDB Table**: No longer needed (Azure Storage handles state locking natively)
- **AWS-specific modules**: `create_dynamoDB` module is deprecated

## 🚀 Quick Start

### 1. Prerequisites
```bash
# Verify tools are installed
terraform version  # v1.0+
az version        # Latest Azure CLI
```

### 2. Configuration
```bash
# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit with your credentials
# Required:
# - azure_subscription_id   (from Azure Portal > Subscriptions)
# - azure_tenant_id         (from Azure Portal > Azure AD > Properties)
```

### 3. Backend Setup
```powershell
# Windows users
.\bootstrap-backend.ps1

# Or manually
az storage account create --name tfstatestorageaccount -g rg-terraform-state
az storage container create --name tfstate --account-name tfstatestorageaccount
```

### 4. Deploy
```bash
# Initialize Terraform
terraform init

# Review changes
terraform plan

# Apply configuration
terraform apply
```

### 5. Verify Deployment
```bash
# Get VM public IP
terraform output vm_public_ip

# Get SSH private key
terraform output -raw ssh_private_key > vm_key.pem
chmod 600 vm_key.pem

# Connect to VM
ssh -i vm_key.pem azureuser@<PUBLIC_IP>
```

## 📊 Key Improvements in Azure

1. **Integrated State Locking**: Azure Storage Account provides native locking (no separate DynamoDB needed)
2. **Simplified Authentication**: Azure provider handles service principal auth natively
3. **Unified Networking**: Single VNet contains all resources with easy management
4. **Auto-Generated SSH Keys**: TLS provider creates RSA-4096 keys automatically (no key management issues)
5. **Blob Versioning**: Native versioning support for state file recovery
6. **HTTPS Enforcement**: Storage account configured for HTTPS-only

## 🔐 Security Features

✅ **Network Security Group**: SSH access only from authorized IPs
✅ **HTTPS-Only Storage**: All data in transit is encrypted
✅ **State Encryption**: Terraform state stored on encrypted Azure storage
✅ **SSH Key Security**: Auto-generated, 4096-bit RSA keys
✅ **Sensitive Outputs**: Marked sensitive in Terraform state
✅ **Private Container**: Storage container access is private (not public)

## 💰 Cost Estimation

| Resource | Estimated Monthly Cost | Notes |
|----------|----------------------|-------|
| Standard_B1s VM | $10-15 | ~1 CPU, 1 GB RAM |
| Storage Account (LRS) | $1-2 | 50GB included |
| Network Resources | $0-3 | Public IP, VNet |
| **Total** | **~$15-20** | Excludes Azure credits |

*Note: Azure subscription 1 may include free credits. Monitor in Cost Management + Billing.*

## 📝 Module Reference

### create_resource_group Module
**Creates**: Resource Group, Virtual Network, Subnet, Network Security Group

**Inputs**:
- `resource_group_name`: RG name (default: "rg-test")
- `location`: Azure region (default: "East US")
- `vnet_address_space`: CIDR blocks (default: ["10.0.0.0/16"])
- `subnet_address_prefix`: Subnet CIDR (default: ["10.0.1.0/24"])

**Outputs**:
- `resource_group_name`, `resource_group_id`
- `vnet_id`
- `subnet_id`
- `nsg_id`

### create_ec2 Module (Azure VM)
**Creates**: Virtual Machine, Network Interface, Public IP, SSH Key Pair

**Inputs**:
- `resource_group_name`: RG name
- `location`: Azure region
- `vm_name`: VM name (default: "vm-ubuntu")
- `vm_size`: VM SKU (default: "Standard_B1s")
- `subnet_id`: Subnet for NIC placement
- `vm_admin_username`: Linux admin user (default: "azureuser")

**Outputs**:
- `vm_id`, `vm_name`
- `public_ip_address`
- `ssh_private_key` (sensitive)

### create_s3 Module (Storage Account)
**Creates**: Storage Account, Blob Container, Versioning Policy

**Inputs**:
- `storage_account_name`: SA name (must be globally unique)
- `resource_group_name`: RG name
- `location`: Azure region

**Outputs**:
- `storage_account_id`, `storage_account_name`
- `container_name`
- `primary_blob_endpoint`

## 🔍 Troubleshooting

### Authentication Issues
```
Error: Failed to authenticate: Client authentication failed
```
**Solution**: Verify credentials in `terraform.tfvars`
```bash
az login --service-principal \
  -u 1464e5df-c763-4ee2-a66f-ba60fb01ebc7 \
  -p YOUR_SECRET \
  --tenant YOUR_TENANT_ID
```

### Storage Account Name Collision
```
Error: Storage Account account name is not available
```
**Solution**: Storage accounts must be globally unique. Update `storage_account_name` variable (lowercase alphanumeric only, 3-24 chars).

### Backend State Lock Issues
```
Error: Error acquiring the lease for the blob
```
**Solution**: 
1. Verify backend storage account exists and is accessible
2. Check storage account key/permissions
3. Re-run `terraform init` if needed

### VM Connection Issues
```
Permission denied (publickey)
```
**Solution**:
```bash
# Verify SSH key permissions
chmod 600 vm_key.pem
# Verify SSH is enabled (NSG rules)
az network nsg rule list -g rg-test --nsg-name nsg-main
```

## 📚 Additional Resources

- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Azure Terraform Backend](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage)
- [Azure Virtual Networks](https://learn.microsoft.com/en-us/azure/virtual-network/)
- [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/)

## ✅ Checklist for Deployment

- [ ] Azure subscription created ("Azure subscription 1")
- [ ] Service principal credentials obtained
- [ ] Tenant ID and Subscription ID retrieved from Azure Portal
- [ ] `terraform.tfvars` file created with credentials
- [ ] `terraform.tfvars` added to `.gitignore` (already done)
- [ ] Backend infrastructure created (via bootstrap scripts or manual)
- [ ] `terraform init` completed successfully
- [ ] `terraform plan` reviewed and approved
- [ ] `terraform apply` executed
- [ ] VM is accessible via SSH
- [ ] Terraform state stored in Azure Storage Account

---

**Last Updated**: 2026-04-02
**Terraform Version**: >= 1.0
**Azure Provider Version**: >= 3.0
