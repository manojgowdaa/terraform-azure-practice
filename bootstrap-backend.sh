#!/bin/bash
# Bootstrap script to create Terraform backend resources in Azure
# This creates the storage account needed for storing Terraform state

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Azure Terraform Backend Bootstrap${NC}"
echo "This script creates the Storage Account for Terraform state storage"
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Error: Azure CLI is not installed${NC}"
    echo "Please install it from: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if user is logged in
if ! az account show > /dev/null 2>&1; then
    echo -e "${YELLOW}You need to log in to Azure${NC}"
    az login
fi

# Setup variables
BACKEND_RG="rg-terraform-state"
BACKEND_STORAGE="tfstatestorageaccount"
BACKEND_LOCATION="eastus"
BACKEND_CONTAINER="tfstate"

echo ""
echo "Backend Configuration:"
echo "  Resource Group: $BACKEND_RG"
echo "  Storage Account: $BACKEND_STORAGE"
echo "  Location: $BACKEND_LOCATION"
echo "  Container: $BACKEND_CONTAINER"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

# Create resource group
echo -e "${YELLOW}Creating resource group: $BACKEND_RG${NC}"
az group create \
    --name "$BACKEND_RG" \
    --location "$BACKEND_LOCATION" \
    --output none

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Resource group created${NC}"
else
    echo -e "${RED}✗ Failed to create resource group${NC}"
    exit 1
fi

# Create storage account
echo -e "${YELLOW}Creating storage account: $BACKEND_STORAGE${NC}"
az storage account create \
    --resource-group "$BACKEND_RG" \
    --name "$BACKEND_STORAGE" \
    --sku Standard_LRS \
    --kind StorageV2 \
    --location "$BACKEND_LOCATION" \
    --access-tier Hot \
    --https-only true \
    --output none

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Storage account created${NC}"
else
    echo -e "${RED}✗ Failed to create storage account${NC}"
    exit 1
fi

# Create storage container
echo -e "${YELLOW}Creating storage container: $BACKEND_CONTAINER${NC}"
az storage container create \
    --account-name "$BACKEND_STORAGE" \
    --name "$BACKEND_CONTAINER" \
    --auth-mode login \
    --output none

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Storage container created${NC}"
else
    echo -e "${RED}✗ Failed to create storage container${NC}"
    exit 1
fi

# Enable versioning
echo -e "${YELLOW}Enabling blob versioning${NC}"
az storage account blob-service-properties update \
    --account-name "$BACKEND_STORAGE" \
    --resource-group "$BACKEND_RG" \
    --enable-versioning true \
    --output none

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Blob versioning enabled${NC}"
else
    echo -e "${RED}✗ Failed to enable versioning${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Backend infrastructure setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Update terraform.tfvars with your Azure credentials"
echo "2. Run: terraform init"
echo "3. Run: terraform plan"
echo "4. Run: terraform apply"
echo ""
