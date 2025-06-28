# GitHub Actions Pipelines for Terraform AKS Deployment

This directory contains GitHub Actions workflows for automating the deployment and management of Azure Kubernetes Service (AKS) using Terraform.

## 📋 Available Workflows

### 1. **terraform-deploy.yml** - Main Deployment Pipeline
- **Triggers:** Push to main/develop, Pull Requests, Manual dispatch
- **Purpose:** Deploy AKS infrastructure with Terraform
- **Features:**
  - Automatic plan on PRs with comments
  - Auto-apply on main branch pushes
  - Manual apply/destroy actions
  - Cluster verification after deployment

### 2. **terraform-backend-setup.yml** - State Backend Setup
- **Triggers:** Manual dispatch only
- **Purpose:** Set up Azure Storage backend for Terraform state
- **Features:**
  - Creates storage account and container
  - Generates backend.tf configuration
  - Secure state management

### 3. **terraform-environments.yml** - Multi-Environment Deployment
- **Triggers:** Push to develop/staging/main, Manual dispatch
- **Purpose:** Manage multiple environments with different configurations
- **Features:**
  - Environment-specific configurations
  - Branch-based environment mapping
  - Production protection rules

### 4. **terraform-security.yml** - Security Scanning
- **Triggers:** Push and Pull Requests
- **Purpose:** Security analysis of Terraform code
- **Features:**
  - TFSec scanning
  - Checkov analysis
  - Trivy configuration scanning
  - SARIF report generation

## 🚀 Quick Start

### Prerequisites

1. **Azure Service Principal** with appropriate permissions
2. **GitHub Secrets** configured
3. **GitHub Environments** set up (optional, for production)

### Setup Steps

#### 1. Create Azure Service Principal

```bash
# Create service principal
az ad sp create-for-rbac \
  --name "github-actions-terraform" \
  --role contributor \
  --scopes /subscriptions/<subscription-id> \
  --sdk-auth
```

#### 2. Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions, and add:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `AZURE_CREDENTIALS` | Service principal credentials | JSON output from az ad sp create-for-rbac |
| `AZURE_LOCATION` | Azure region | East US |
| `KUBERNETES_VERSION` | Kubernetes version | 1.28.0 |

#### 3. Set up Terraform Backend (Optional but Recommended)

1. Go to Actions → terraform-backend-setup
2. Click "Run workflow"
3. Fill in the details:
   - Storage account name: `tfstateaks`
   - Resource group: `rg-terraform-state`
   - Location: `East US`
4. Run the workflow
5. Commit the generated `backend.tf` file

#### 4. Configure Environments (Optional)

For production deployments, set up GitHub Environments:

1. Go to Settings → Environments
2. Create environments: `dev`, `staging`, `prod`
3. Add protection rules for production:
   - Required reviewers
   - Wait timer
   - Deployment branches

## 🔧 Workflow Usage

### Automatic Deployment

**Push to main branch:**
- Triggers automatic deployment
- Runs terraform plan and apply
- Verifies cluster status

**Pull Request:**
- Runs terraform plan
- Posts plan results as PR comment
- No automatic apply

### Manual Deployment

**Using workflow_dispatch:**

1. Go to Actions → terraform-deploy
2. Click "Run workflow"
3. Select:
   - Action: `plan`, `apply`, or `destroy`
   - Environment: `dev`, `staging`, or `prod`

### Multi-Environment Deployment

**Branch-based deployment:**
- `develop` branch → `dev` environment
- `staging` branch → `staging` environment  
- `main` branch → `prod` environment

**Environment-specific configurations:**
- Different node counts and VM sizes
- Separate resource groups and clusters
- Environment-specific tags

## 📊 Monitoring and Verification

### Deployment Verification

After deployment, the pipeline automatically:
- Gets AKS credentials
- Verifies cluster status
- Checks node availability
- Validates system pods

### Security Scanning

The security pipeline runs:
- **TFSec:** Terraform security scanner
- **Checkov:** Infrastructure as Code security scanner
- **Trivy:** Configuration vulnerability scanner

Results are available in:
- GitHub Security tab
- SARIF reports
- Workflow summary

## 🔒 Security Best Practices

### Secrets Management
- Use GitHub Secrets for sensitive data
- Rotate service principal credentials regularly
- Use least-privilege access for service principals

### Environment Protection
- Require approvals for production deployments
- Use branch protection rules
- Implement deployment windows

### Code Security
- Regular security scanning
- Code review requirements
- Infrastructure drift detection

## 🛠️ Troubleshooting

### Common Issues

**1. Authentication Errors**
```bash
# Verify service principal
az ad sp list --display-name "github-actions-terraform"

# Check permissions
az role assignment list --assignee <service-principal-id>
```

**2. Terraform State Issues**
```bash
# Reinitialize with backend
terraform init -reconfigure

# Check state
terraform state list
```

**3. AKS Deployment Failures**
```bash
# Check cluster status
az aks show --resource-group <rg-name> --name <cluster-name>

# View cluster logs
az aks diagnostics collect --resource-group <rg-name> --name <cluster-name>
```

### Debug Workflows

**Enable debug logging:**
1. Go to repository Settings → Actions → General
2. Enable "Debug logging"
3. Re-run failed workflow

**View workflow logs:**
- Go to Actions tab
- Click on specific workflow run
- Download logs for detailed analysis

## 📈 Cost Optimization

### Pipeline Optimizations
- Use `paths` filters to trigger only on relevant changes
- Implement caching for Terraform providers
- Use reusable workflows for common tasks

### Infrastructure Optimizations
- Enable auto-scaling for cost efficiency
- Use spot instances for non-critical workloads
- Implement resource tagging for cost tracking

## 🔄 Maintenance

### Regular Tasks
- Update Terraform and provider versions
- Rotate service principal credentials
- Review and update security policies
- Monitor pipeline performance

### Version Updates
1. Update `TF_VERSION` in workflows
2. Test in development environment
3. Update provider versions in `versions.tf`
4. Run security scans after updates

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [TFSec Documentation](https://aquasecurity.github.io/tfsec/)
- [Checkov Documentation](https://www.checkov.io/)

## 🤝 Contributing

When contributing to the pipelines:
1. Test changes in a development environment
2. Update documentation
3. Follow security best practices
4. Add appropriate tests and validations

## 📄 License

This pipeline configuration is provided as-is for educational and deployment purposes. 