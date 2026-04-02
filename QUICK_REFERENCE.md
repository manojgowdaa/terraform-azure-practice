# Terraform Azure - Quick Reference

## Initial Setup

```bash
# 1. Get your Tenant ID
az account show --query tenantId -o tsv

# 2. Get your Subscription ID  
az account show --query id -o tsv

# 3. Create terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars and add:
#   - azure_tenant_id
#   - azure_subscription_id

# 4. Setup backend (choose one):

## Option A: PowerShell (Windows)
.\bootstrap-backend.ps1

## Option B: Bash (Linux/Mac)
bash bootstrap-backend.sh

## Option C: Manual with Azure CLI
az group create -n rg-terraform-state -l eastus
az storage account create -n tfstatestorageaccount -g rg-terraform-state -l eastus --sku Standard_LRS
az storage container create -n tfstate -a tfstatestorageaccount
az storage account blob-service-properties update -a tfstatestorageaccount -g rg-terraform-state --enable-versioning true

# 5. Initialize Terraform
terraform init

# 6. Plan deployment
terraform plan

# 7. Apply configuration
terraform apply
```

## Common Operations

### View Infrastructure
```bash
# Get all outputs
terraform output

# Get specific output
terraform output vm_public_ip
terraform output resource_group_name

# Get sensitive output (SSH key)
terraform output -raw ssh_private_key > vm_key.pem
chmod 600 vm_key.pem
```

### Manage Resources
```bash
# Refresh state
terraform refresh

# Plan without applying
terraform plan -out=tfplan

# Apply specific resource
terraform apply -target=module.create_resource_group

# Destroy all
terraform destroy

# Destroy specific resource
terraform destroy -target=module.create_azure_vm
```

### State Management
```bash
# List all resources in state
terraform state list

# Show specific resource state
terraform state show azurerm_resource_group.rg_main

# Remove resource from state (doesn't delete in Azure)
terraform state rm azurerm_resource_group.rg_main

# Replace state
terraform state replace-provider hashicorp/azurerm registry.terraform.io/hashicorp/azurerm
```

### Debugging
```bash
# Enable debug logging
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Disable debug logging
unset TF_LOG
unset TF_LOG_PATH

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Check for issues
terraform plan -json | grep -i error
```

### Version Management
```bash
# Show Terraform version
terraform version

# Show provider versions
terraform providers

# Get provider information
terraform providers schema
```

## VM Access

### Connect via SSH
```bash
# Get public IP
PUBLIC_IP=$(terraform output -raw vm_public_ip)

# Get SSH key
terraform output -raw ssh_private_key > vm_key.pem
chmod 600 vm_key.pem

# Connect
ssh -i vm_key.pem azureuser@$PUBLIC_IP
```

### Troubleshoot SSH
```bash
# Test SSH connectivity
ssh -vvv -i vm_key.pem azureuser@<IP>

# Check NSG rules
az network nsg rule list -g rg-test --nsg-name nsg-main

# Check VM status
az vm get-instance-view -g rg-test -n vm-ubuntu-0 --query instanceView.statuses
```

## Azure CLI Commands (Complementary)

```bash
# List all resources in resource group
az resource list -g rg-test --output table

# Get storage account keys
az storage account keys list -g rg-test -n storageaccttest

# Download Terraform state from storage
az storage blob download \
  -c tfstate \
  -n terraform.tfstate \
  -a tfstatestorageaccount \
  -f local-state.tfstate

# Check service principal (verify credentials)
az account show
```

## Useful Terraform Variables

### Override defaults at runtime
```bash
# Pass variables via command line
terraform apply \
  -var="resource_group_name=rg-prod" \
  -var="vm_size=Standard_B2s"

# Use variable file
terraform apply -var-file="prod.tfvars"

# Set environment variables
export TF_VAR_resource_group_name="rg-prod"
terraform apply
```

## File Organization

Keep these files in Git:
- `*.tf` (all Terraform files)
- `*.tfvars.example`
- `*.sh` and `*.ps1` (bootstrap scripts)
- `*.md` (documentation)
- `.gitignore`

Keep these files LOCAL ONLY (add to .gitignore):
- `terraform.tfvars` (credentials)
- `*.tfstate` (state files)
- `*.tfstate.backup`
- `.terraform/` (cached modules)
- `.terraform.lock.hcl` (lock file - optional in shared repos)
- `vm_key.pem` (SSH keys)
- `terraform.log` (debug logs)

## Cost Monitoring

```bash
# Get current cost estimates
az costmanagement query --timeframe ActualLastMonth -g rg-test

# List resource groups by cost
az resource list --output json | \
  jq -r '.[] | "\(.resourceGroup)"' | \
  sort | uniq -c

# Check storage account size
az storage account show-usage -n storageaccttest -g rg-test
```

## Cleanup

### Remove Azure resources (via Terraform)
```bash
terraform destroy
```

### Remove Azure resources (via Azure CLI) - if Terraform state is lost
```bash
az group delete -n rg-test --yes
az group delete -n rg-terraform-state --yes
```

### Remove Terraform local files
```bash
rm -rf .terraform/
rm -f .terraform.lock.hcl
rm -f terraform.tfstate*
rm -f terraform.log
```

## Environment Setup (One-time)

### Linux/Mac
```bash
# Install Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Install Azure CLI
brew install azure-cli

# Configure shell profile
echo 'export TF_VERSION=$(terraform version -json | jq -r .terraform_version)' >> ~/.zshrc
```

### Windows (PowerShell)
```powershell
# Install Terraform
choco install terraform

# Install Azure CLI
choco install azure-cli

# Configure PowerShell profile
notepad $PROFILE
# Add: $env:Path += ";C:\Program Files\Terraform"
```

## Pre-deployment Checklist

- [ ] Terraform version >= 1.0
- [ ] Azure CLI installed and authenticated
- [ ] `terraform.tfvars` file created
- [ ] Credentials verified in Azure Portal
- [ ] Backend storage account exists
- [ ] Sufficient Azure account permissions
- [ ] Enough Azure credits/budget
- [ ] Network connectivity to Azure
- [ ] `.gitignore` properly configured

---

**Quick Help**: `terraform -help` or `terraform <command> -help`
