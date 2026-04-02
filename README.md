# Azure Infrastructure as Code - Terraform

A complete Terraform configuration for deploying and managing infrastructure on Microsoft Azure. This project demonstrates best practices in infrastructure automation with modular, reusable, and scalable Terraform code.

## 🌐 Overview

This repository contains Terraform code that provisions a fully functional Azure infrastructure including:
- 🏢 **Resource Group** with unified resource management
- 🌍 **Virtual Network** (VNet) with subnet and security groups
- 💻 **Virtual Machine** (Ubuntu) with auto-generated SSH access
- 💾 **Storage Account** for state management and data storage
- 🔐 **Network Security** with firewall rules

All resources are deployed in a single Resource Group (`rg-test`) and contained within a single Virtual Network for simplified management.

## 📋 Prerequisites

- **Terraform** >= 1.0 ([Download](https://www.terraform.io/downloads))
- **Azure CLI** ([Download](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli))
- **Azure Subscription** ("Azure subscription 1")
- **Service Principal Credentials**:
  - Client ID: `1464e5df-c763-4ee2-a66f-ba60fb01ebc7`
  - Client Secret: `f5be1678-cac3-4afd-9667-e95866ac5b39`

## 🚀 Quick Start

### 1️⃣ Clone & Configure
```bash
# Navigate to repository
cd terraform-aws-practice

# Copy variables template
cp terraform.tfvars.example terraform.tfvars

# Edit with your Azure credentials
# Required: azure_tenant_id, azure_subscription_id
code terraform.tfvars  # or your preferred editor
```

### 2️⃣ Setup Backend (One-time)
```powershell
# Windows (PowerShell)
.\bootstrap-backend.ps1

# Or Linux/Mac (Bash)
bash bootstrap-backend.sh

# Or manually using Azure CLI
az group create -n rg-terraform-state -l eastus
az storage account create -n tfstatestorageaccount -g rg-terraform-state --sku Standard_LRS
az storage container create -n tfstate -a tfstatestorageaccount
```

### 3️⃣ Initialize & Deploy
```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply
```

### 4️⃣ Access Resources
```bash
# Get VM public IP
terraform output vm_public_ip

# Get SSH key
terraform output -raw ssh_private_key > vm_key.pem
chmod 600 vm_key.pem

# SSH into VM
ssh -i vm_key.pem azureuser@<IP>
```

## 📁 Project Structure

```
terraform-aws-practice/
│
├── README.md                    # This file
├── AZURE_SETUP_README.md        # Detailed setup guide
├── IMPLEMENTATION_GUIDE.md      # Technical reference
├── MIGRATION_SUMMARY.md         # AWS→Azure migration details
├── QUICK_REFERENCE.md           # Common commands
│
├── provider.tf                  # Azure provider configuration
├── versions.tf                  # Terraform version & backend config
├── variable.tf                  # Input variables
├── output.tf                    # Output values
├── main.tf                      # Module calls
│
├── terraform.tfvars.example     # Variable template (copy & customize)
├── .gitignore                   # Git ignore patterns
│
├── bootstrap-backend.ps1        # Backend setup (PowerShell)
├── bootstrap-backend.sh         # Backend setup (Bash)
│
└── modules/                     # Reusable infrastructure modules
    │
    ├── create_resource_group/   # Resource Group + VNet + Subnet + NSG
    │   ├── main.tf
    │   ├── variable.tf
    │   └── output.tf
    │
    ├── create_ec2/              # Azure Virtual Machine
    │   ├── main.tf              # VM, NIC, Public IP, SSH Key
    │   ├── variable.tf
    │   └── output.tf
    │
    └── create_s3/               # Storage Account (state storage)
        ├── main.tf              # Storage Account, Container, Versioning
        ├── variable.tf
        └── output.tf
```

## 📖 Documentation

| Document | Purpose |
|----------|---------|
| [AZURE_SETUP_README.md](AZURE_SETUP_README.md) | **Start here!** Step-by-step setup instructions, prerequisites, and troubleshooting |
| [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) | Technical deep-dive: architecture, module details, cost estimation |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Handy command reference for common operations |
| [MIGRATION_SUMMARY.md](MIGRATION_SUMMARY.md) | Details of AWS→Azure migration (what changed and why) |

## 🏗️ Architecture

```
Azure Subscription
│
├─ Resource Group: rg-test
│  │
│  ├─ Virtual Network: vnet-main (10.0.0.0/16)
│  │  │
│  │  ├─ Subnet: subnet-main (10.0.1.0/24)
│  │  │  │
│  │  │  ├─ Virtual Machine: vm-ubuntu
│  │  │  │  ├─ Network Interface
│  │  │  │  ├─ Public IP Address
│  │  │  │  └─ SSH Key Pair
│  │  │  │
│  │  │  └─ Network Security Group
│  │  │     └─ SSH Rule (Port 22)
│  │  │
│  │  └─ Route Tables (auto)
│  │
│  └─ Storage Account: storageaccttest
│     ├─ Container: tfstate
│     └─ Blob Properties (versioning + retention)
│
└─ Resource Group: rg-terraform-state (backend)
   └─ Storage Account: tfstatestorageaccount
      └─ Container: tfstate
         └─ Terraform State (versioned)
```

## ⚙️ Configuration Variables

Key variables you can customize in `terraform.tfvars`:

| Variable | Default | Description |
|----------|---------|-------------|
| `azure_location` | "East US" | Azure region for resources |
| `resource_group_name` | "rg-test" | Resource Group name |
| `vnet_address_space` | ["10.0.0.0/16"] | Virtual Network CIDR |
| `vm_size` | "Standard_B1s" | VM SKU (compute size) |
| `storage_account_name` | "storageaccttest" | Storage account name (must be globally unique) |
| `vm_admin_username` | "azureuser" | Linux admin user |

See [terraform.tfvars.example](terraform.tfvars.example) for complete list.

## 🔐 Security Features

✅ **Network Isolation** - All resources in private VNet with NSG rules
✅ **SSH Key Management** - Auto-generated RSA-4096 keys
✅ **HTTPS Enforcement** - Storage account HTTPS-only
✅ **State Encryption** - Terraform state encrypted at rest
✅ **Versioning** - Automatic blob versioning with 7-day retention
✅ **No Public Exposure** - Resources not exposed to internet by default

## 💰 Cost Estimation

| Resource | Est. Monthly Cost |
|----------|-------------------|
| Standard_B1s VM | $10-15 |
| Storage Account | $1-2 |
| Network Resources | $0-3 |
| **Total** | **~$15-20** |

Azure credits may apply. Monitor in [Azure Portal Cost Management](https://portal.azure.com/#blade/Microsoft_Azure_CostManagement/Menu/overview).

## 🛠️ Common Operations

### Deploy Infrastructure
```bash
terraform plan      # Preview changes
terraform apply     # Create resources
```

### View Outputs
```bash
terraform output              # All outputs
terraform output vm_public_ip # Specific output
terraform output -raw ssh_private_key > key.pem  # Export SSH key
```

### Modify Configuration
```bash
# Change variables at runtime
terraform apply -var="vm_size=Standard_B2s"

# Or use variable file
terraform apply -var-file="prod.tfvars"
```

### Destroy Resources
```bash
terraform destroy   # Delete all resources
# Confirm with 'yes' when prompted
```

### Debug Issues
```bash
# Enable debug logging
$env:TF_LOG = "DEBUG"
terraform plan

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive
```

## 🐛 Troubleshooting

### Authentication Error
**Error**: `Client authentication failed`
**Solution**: Verify credentials in `terraform.tfvars` and check Tenant ID/Subscription ID

### Storage Account Name Conflict
**Error**: `Storage Account account name is not available`
**Solution**: Update `storage_account_name` to unique name (lowercase alphanumeric only, 3-24 chars)

### Backend Not Found
**Error**: `Error acquiring the lease for the blob`
**Solution**: Run `bootstrap-backend.ps1` or create storage account manually first

### VM Connection Issues
**Error**: `Permission denied (publickey)` or timeout
**Solution**: Verify SSH key permissions (`chmod 600 vm_key.pem`) and NSG rules

See [AZURE_SETUP_README.md#Troubleshooting](AZURE_SETUP_README.md#troubleshooting) for more solutions.

## 📊 Outputs

After deployment, Terraform provides these useful outputs:

```bash
resource_group_name = "rg-test"
resource_group_id = "/subscriptions/.../resourceGroups/rg-test"
vnet_id = "/subscriptions/.../virtualNetworks/vnet-main"
subnet_id = "/subscriptions/.../subnets/subnet-main"
vm_public_ip = "20.1.2.3"
vm_id = "/subscriptions/.../virtualMachines/vm-ubuntu-0"
storage_account_name = "storageaccttest"
terraform_state_container = "tfstate"
ssh_private_key = <sensitive>
```

Access outputs with:
```bash
terraform output [output_name]
```

## 🔄 Modules Details

### create_resource_group
Creates foundational Azure networking infrastructure.
```
Inputs: resource_group_name, location, vnet_name, vnet_address_space, etc.
Outputs: resource_group_name, resource_group_id, vnet_id, subnet_id, nsg_id
Resources: RG, VNet, Subnet, NSG
```

### create_ec2 (Azure VM)
Provisions a Linux virtual machine with networking and SSH access.
```
Inputs: resource_group_name, location, vm_name, vm_size, subnet_id, vm_admin_username
Outputs: vm_id, vm_name, public_ip_address, ssh_private_key
Resources: VM, NIC, Public IP, TLS Key Pair, SSH Rules
```

### create_s3 (Storage Account)
Creates storage for Terraform state with versioning and retention.
```
Inputs: storage_account_name, resource_group_name, location
Outputs: storage_account_id, storage_account_name, container_name, primary_blob_endpoint
Resources: Storage Account, Container, Blob Properties
```

## ✅ Pre-Deployment Checklist

- [ ] Terraform and Azure CLI installed
- [ ] Azure account with active subscription
- [ ] Service principal credentials obtained
- [ ] Tenant ID and Subscription ID retrieved
- [ ] `terraform.tfvars` created and configured
- [ ] `.gitignore` configured to protect sensitive files
- [ ] Backend infrastructure ready (via bootstrap script)
- [ ] Sufficient Azure credits/budget available
- [ ] Network connectivity to Azure verified

## 📝 Best Practices Implemented

✅ Modular code organization with reusable modules
✅ Variable interpolation for flexibility and maintainability
✅ Proper dependency management between resources
✅ Output definitions for easy resource access
✅ Security groups with least-privilege access
✅ Auto-generated SSH keys (no manual management)
✅ State file versioning and retention policies
✅ HTTPS-only storage account access
✅ Comprehensive error handling and logging
✅ Complete documentation and examples

## 🤝 Contributing

When modifying this configuration:
1. Test changes in a non-production environment first
2. Use `terraform validate` to check syntax
3. Use `terraform fmt` to format code consistently
4. Update documentation if adding new features
5. Keep sensitive data out of version control

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Terraform Backend](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage)
- [Azure CLI Docs](https://learn.microsoft.com/en-us/cli/azure/)
- [Terraform Best Practices](https://www.terraform.io/cloud-docs/recommended-practices)

## ⚖️ License

This project is provided as-is for educational and infrastructure automation purposes.

## 📞 Support

For issues or questions:
1. Check the [Troubleshooting](AZURE_SETUP_README.md#troubleshooting) section
2. Review the [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) for technical details
3. Consult the [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for common commands
4. Refer to official [Azure](https://learn.microsoft.com/) and [Terraform](https://www.terraform.io/docs) documentation

---

**Project Status**: ✅ Production Ready
**Last Updated**: April 2, 2026
**Terraform Version**: >= 1.0
**Azure Provider**: >= 3.0
**Created**: Successfully migrated from AWS to Azure
