# GitHub Actions CI/CD Pipeline Setup

This document describes the GitHub Actions CI/CD pipeline for building and deploying the UI app to Azure App Service.

## Pipeline Overview

The `deploy-ui.yml` workflow automates:
1. **Build** - Builds a Docker image of the UI application
2. **Push** - Pushes the image to Azure Container Registry (ACR)
3. **Deploy** - Updates the App Service with the new Docker image

## Triggered Events

- **Push to main branch** - When files in `ui/` or `.github/workflows/deploy-ui.yml` change
- **Manual trigger** - Via `workflow_dispatch` for on-demand deployments

## Required GitHub Secrets

Configure these secrets in your GitHub repository (Settings → Secrets and variables → Actions):

### 1. Azure Credentials
**Secret Name:** `AZURE_CREDENTIALS`

Generate using Azure CLI:
```bash
az ad sp create-for-rbac --name "github-actions-sp" --role="Contributor" --scopes="/subscriptions/{SUBSCRIPTION_ID}" --json > azure-credentials.json
```

Paste the entire JSON output as the secret value.

### 2. Container Registry Details
**Secret Names:**
- `REGISTRY_LOGIN_SERVER` - ACR login server (e.g., `acrterraformtest2026.azurecr.us`)
- `REGISTRY_USERNAME` - ACR username (usually same as ACR name)
- `REGISTRY_PASSWORD` - ACR admin password

Get these from Azure Portal → Container Registries → Access keys

### 3. App Service Details
**Secret Name:** `APP_SERVICE_NAME` - Name of your App Service (e.g., `webapp-linux-tf20260`)

## Setup Instructions

### Step 1: Create Azure Service Principal
```bash
# Login to Azure
az login

# Create service principal with Contributor role
az ad sp create-for-rbac --name "github-actions-sp" --role="Contributor" --scopes="/subscriptions/{SUBSCRIPTION_ID}"

# Save the output JSON for GitHub secrets
```

### Step 2: Enable ACR Admin User
```bash
az acr update --name {ACR_NAME} --admin-enabled true
```

### Step 3: Get ACR Credentials
```bash
az acr credential show --name {ACR_NAME}
```

### Step 4: Add GitHub Secrets
1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions → New repository secret
3. Add all required secrets listed above

### Step 5: Create/Update Docker Image
Ensure you have:
- `ui/` directory with your application source
- `ui/Dockerfile` with build instructions (provided in this repo)

### Step 6: Push to Main Branch
```bash
git add .
git commit -m "Add GitHub Actions CI/CD pipeline"
git push origin main
```

## Pipeline Execution

### First Run
The pipeline will:
1. Build the Docker image
2. Push to ACR with tags: `{sha}` and `latest`
3. Update App Service to use the new image
4. If successful, display ✅ notification

### Subsequent Runs
Each push to main automatically triggers a new build and deployment with the updated Docker image.

## Monitoring

### View Workflow Runs
1. Go to GitHub repository → Actions
2. Select "Build and Deploy UI App to App Service"
3. View real-time logs and status

### Troubleshooting

**"Authentication failed" error:**
- Verify `AZURE_CREDENTIALS` is valid JSON from `az ad sp create-for-rbac`
- Check service principal has Contributor role

**"Image push failed" error:**
- Verify `REGISTRY_LOGIN_SERVER`, `REGISTRY_USERNAME`, `REGISTRY_PASSWORD` are correct
- Ensure ACR admin user is enabled

**"App Service update failed" error:**
- Verify `APP_SERVICE_NAME` is correct
- Check App Service is configured for Docker container deployment
- Ensure image is actually pushed to ACR

## Docker Image URL Format

Images are tagged with:
- **Specific commit:** `{REGISTRY_LOGIN_SERVER}/{IMAGE_NAME}:{COMMIT_SHA}`
- **Latest:** `{REGISTRY_LOGIN_SERVER}/{IMAGE_NAME}:latest`

Example:
```
acrterraformtest2026.azurecr.us/ui-app:abc123def456
acrterraformtest2026.azurecr.us/ui-app:latest
```

## Security Best Practices

1. **Scope Service Principal** - Limit to specific resource group if possible
2. **Rotate Credentials** - Regenerate ACR passwords periodically
3. **Use GitHub Environment Secrets** - For production deployments, use GitHub Environments
4. **Review Logs** - Regularly check workflow logs for suspicious activity
5. **Minimal Permissions** - Service principal should have only required roles

## Manual Deployment

Run deployment manually without pushing code:
1. Go to GitHub repository → Actions
2. Select "Build and Deploy UI App to App Service"
3. Click "Run workflow"
4. Select branch and click "Run workflow"
