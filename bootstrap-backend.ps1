# Bootstrap script to create Terraform backend resources in Azure (PowerShell)
# This creates the storage account needed for storing Terraform state

# Stop on any error
$ErrorActionPreference = "Stop"

Write-Host "Azure Terraform Backend Bootstrap" -ForegroundColor Yellow
Write-Host "This script creates the Storage Account for Terraform state storage"
Write-Host ""

# Check if Azure CLI is installed
try {
    $azVersion = az version 2>&1 | ConvertFrom-Json
    Write-Host "✓ Azure CLI installed (version: $($azVersion.'azure-cli'))" -ForegroundColor Green
} catch {
    Write-Host "✗ Error: Azure CLI is not installed" -ForegroundColor Red
    Write-Host "Please install it from: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
}

# Check if user is authenticated
try {
    $account = az account show 2>&1 | ConvertFrom-Json
    Write-Host "✓ Logged in as: $($account.user.name)" -ForegroundColor Green
} catch {
    Write-Host "Attempting to log in to Azure..." -ForegroundColor Yellow
    az login
}

# Setup variables
$BACKEND_RG = "rg-terraform-state"
$BACKEND_STORAGE = "tfstatestorageaccount"
$BACKEND_LOCATION = "eastus"
$BACKEND_CONTAINER = "tfstate"

Write-Host ""
Write-Host "Backend Configuration:" -ForegroundColor Cyan
Write-Host "  Resource Group: $BACKEND_RG"
Write-Host "  Storage Account: $BACKEND_STORAGE"
Write-Host "  Location: $BACKEND_LOCATION"
Write-Host "  Container: $BACKEND_CONTAINER"
Write-Host ""

$response = Read-Host "Continue? (y/n)"
if ($response -ne "y" -and $response -ne "Y") {
    Write-Host "Cancelled."
    exit 0
}

# Create resource group
Write-Host ""
Write-Host "Creating resource group: $BACKEND_RG" -ForegroundColor Yellow
try {
    az group create `
        --name $BACKEND_RG `
        --location $BACKEND_LOCATION `
        --output none
    Write-Host "✓ Resource group created" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to create resource group: $_" -ForegroundColor Red
    exit 1
}

# Create storage account
Write-Host "Creating storage account: $BACKEND_STORAGE" -ForegroundColor Yellow
try {
    az storage account create `
        --resource-group $BACKEND_RG `
        --name $BACKEND_STORAGE `
        --sku Standard_LRS `
        --kind StorageV2 `
        --location $BACKEND_LOCATION `
        --access-tier Hot `
        --https-only true `
        --output none
    Write-Host "✓ Storage account created" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to create storage account: $_" -ForegroundColor Red
    exit 1
}

# Create storage container
Write-Host "Creating storage container: $BACKEND_CONTAINER" -ForegroundColor Yellow
try {
    az storage container create `
        --account-name $BACKEND_STORAGE `
        --name $BACKEND_CONTAINER `
        --auth-mode login `
        --output none
    Write-Host "✓ Storage container created" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to create storage container: $_" -ForegroundColor Red
    exit 1
}

# Enable versioning
Write-Host "Enabling blob versioning" -ForegroundColor Yellow
try {
    az storage account blob-service-properties update `
        --account-name $BACKEND_STORAGE `
        --resource-group $BACKEND_RG `
        --enable-versioning true `
        --output none
    Write-Host "✓ Blob versioning enabled" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to enable versioning: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✓ Backend infrastructure setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Update terraform.tfvars with your Azure credentials"
Write-Host "2. Run: terraform init"
Write-Host "3. Run: terraform plan"
Write-Host "4. Run: terraform apply"
Write-Host ""
