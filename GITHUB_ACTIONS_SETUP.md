# GitHub Actions Setup Guide

## 🔐 Add GitHub Secrets for Azure Authentication

The GitHub Actions workflow requires 4 secrets to authenticate with Azure. Follow these steps:

### Step 1: Get Your Azure Credentials

1. **Azure Subscription ID**
   - Go to Azure Portal: https://portal.azure.com
   - Navigate to **Subscriptions**
   - Copy the **Subscription ID** for "Azure subscription 1"

2. **Azure Tenant ID**
   - Go to Azure Portal: https://portal.azure.com
   - Navigate to **Azure Active Directory > Properties**
   - Copy the **Tenant ID**

3. **Azure Client ID & Secret** (provided)
   - Client ID: `1464e5df-c763-4ee2-a66f-ba60fb01ebc7`
   - Client Secret: `f5be1678-cac3-4afd-9667-e95866ac5b39`

### Step 2: Add Secrets to GitHub Repository

1. Go to your GitHub repository
2. Navigate to **Settings > Secrets and variables > Actions**
3. Click **New repository secret**

Add these 4 secrets:

| Secret Name | Value | Example |
|-------------|-------|---------|
| `AZURE_CLIENT_ID` | Service Principal Client ID | `1464e5df-c763-4ee2-a66f-ba60fb01ebc7` |
| `AZURE_CLIENT_SECRET` | Service Principal Secret | `f5be1678-cac3-4afd-9667-e95866ac5b39` |
| `AZURE_SUBSCRIPTION_ID` | Your Azure Subscription ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `AZURE_TENANT_ID` | Your Azure Tenant ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |

### Step 3: Verify Workflow Trigger

1. Go to **Actions** tab in your GitHub repository
2. Select **Terraform Deployment** workflow
3. Click **Run workflow > Run workflow** to trigger it manually

The workflow will:
- ✅ Authenticate to Azure using the secrets
- ✅ Create `terraform.tfvars` from secrets
- ✅ Run `terraform init`
- ✅ Validate Terraform code
- ✅ Run `terraform plan`
- ✅ Run `terraform apply`

---

## 🔒 GitHub Workflow Security Features

✅ **Environment Variables**: Credentials passed via environment variables (ARM_* variables)
✅ **GitHub Secrets**: All sensitive values masked in logs
✅ **No Hardcoding**: Zero secrets in code or repository
✅ **Auto-Generated tfvars**: Created during workflow execution
✅ **OIDC Support**: Uses Azure/login@v1 for OIDC authentication
✅ **Log Masking**: GitHub automatically masks all secret values

---

## 📋 Workflow Steps Explained

1. **Checkout Code**: Pulls your Terraform code from the repository
2. **Setup Terraform**: Installs specified Terraform version
3. **Azure Login**: Authenticates to Azure using service principal (from secrets)
4. **Create terraform.tfvars**: Generates variables file from GitHub secrets
5. **Terraform Init**: Initializes Terraform with Azure backend
6. **Terraform Validate**: Validates Terraform code syntax
7. **Terraform Plan**: Creates execution plan
8. **Terraform Apply**: Applies changes to Azure (auto-approved)

---

## ⚠️ Important Security Notes

🔐 **Never commit secrets** - They're only stored in GitHub Secrets
🔐 **Never print secrets** - GitHub automatically masks them in logs
🔐 **Rotate secrets regularly** - Especially the Client Secret
🔐 **Limit permissions** - Service principal should only have necessary Azure roles
🔐 **Audit access** - Review who can trigger the workflow

---

## 🧪 Testing the Workflow

### Test Without Applying Changes
```
Edit .github/workflows/terraform.yml and change the last step to:
- name: Terraform Plan Only
  run: terraform plan
```

### View Logs
- Go to **Actions > Terraform Deployment > [workflow run]**
- All steps and outputs are visible
- Secrets are automatically masked (shown as ****)

---

## 🔄 Manual vs Automated Deployments

**Current Setup** (workflow_dispatch):
- Manual trigger via GitHub Actions UI
- Full control over when to deploy
- No automatic deployments

**To Enable Automatic Deployments** (push to main):
```yaml
on:
  push:
    branches:
      - main
```

**To Add Pull Request Preview** (plan only):
```yaml
on:
  pull_request:
    branches:
      - main
```

---

## 🐛 Troubleshooting

### Authentication Failed
- Verify all 4 secrets are added correctly
- Check Service Principal has permissions in Azure subscription
- Ensure Tenant ID matches your Azure account

### terraform plan fails
- Check `terraform.tfvars` is created correctly
- Verify backend storage account exists (run bootstrap script first)
- Check Azure login successful in logs

### Permission Denied
- Service Principal needs Contributor role on subscription
- Add role in Azure Portal: **Subscriptions > Access Control (IAM)**

---

## 📚 Reference

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure/Login@v1 Documentation](https://github.com/Azure/login)
- [Terraform Environment Variables](https://www.terraform.io/cli/config/environment-variables)
- [Azure SDK Authentication](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-via-service-principal)
