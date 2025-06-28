# Azure Kubernetes Service (AKS) Terraform Deployment

This Terraform configuration deploys a production-ready Azure Kubernetes Service (AKS) cluster with the following features:

## Features

- **AKS Cluster** with latest Kubernetes version
- **Virtual Network** with dedicated subnet for AKS
- **Network Security Group** with basic security rules
- **Azure Monitor** integration for container monitoring
- **Azure Policy** for governance and compliance
- **Auto-scaling** node pool configuration
- **System-assigned managed identity**
- **Maintenance windows** for cluster updates

## Prerequisites

1. **Azure CLI** installed and authenticated
2. **Terraform** version >= 1.0
3. **Azure Subscription** with appropriate permissions
4. **kubectl** (optional, for cluster management)

## Quick Start

1. **Clone and navigate to the terraform directory:**
   ```bash
   cd terraform
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Review the configuration:**
   ```bash
   terraform plan
   ```

4. **Deploy the infrastructure:**
   ```bash
   terraform apply
   ```

5. **Get cluster credentials:**
   ```bash
   az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw cluster_name)
   ```

## Configuration

### Variables

Copy the example variables file and customize it for your environment:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to customize:
- Resource group name and location
- Cluster name and Kubernetes version
- Node pool configuration (VM size, count, auto-scaling)
- Network settings
- Monitoring and policy options
- Tags

### Key Configuration Options

| Variable | Description | Default |
|----------|-------------|---------|
| `resource_group_name` | Name of the resource group | `rg-aks-cluster` |
| `location` | Azure region | `East US` |
| `cluster_name` | AKS cluster name | `aks-cluster` |
| `kubernetes_version` | Kubernetes version | `1.28.0` |
| `node_count` | Number of nodes | `3` |
| `vm_size` | VM size for nodes | `Standard_DS2_v2` |
| `enable_auto_scaling` | Enable auto-scaling | `true` |
| `enable_azure_policy` | Enable Azure Policy | `true` |
| `enable_azure_monitor` | Enable Azure Monitor | `true` |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Azure Subscription                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                Resource Group                           │ │
│  │  ┌─────────────────┐  ┌─────────────────────────────┐   │ │
│  │  │   Virtual       │  │      AKS Cluster            │   │ │
│  │  │   Network       │  │  ┌─────────────────────────┐│   │ │
│  │  │  ┌─────────────┐│  │  │    Node Pool            ││   │ │
│  │  │  │   Subnet    ││  │  │  ┌─────────────────────┐││   │ │
│  │  │  │             ││  │  │  │   VM Scale Set      │││   │ │
│  │  │  └─────────────┘│  │  │  │   (Nodes)           │││   │ │
│  │  └─────────────────┘  │  │  └─────────────────────┘││   │ │
│  │                       │  └─────────────────────────┘│   │ │
│  │  ┌─────────────────┐  │  ┌─────────────────────────┐│   │ │
│  │  │   NSG           │  │  │   Log Analytics        ││   │ │
│  │  │                 │  │  │   Workspace            ││   │ │
│  │  └─────────────────┘  │  └─────────────────────────┘│   │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Outputs

After deployment, Terraform will output:

- **Resource group name**
- **Cluster name and ID**
- **Kubeconfig** (sensitive)
- **Network profile** information
- **Identity** details
- **Log Analytics workspace ID** (if enabled)

## Post-Deployment

### Verify Deployment

1. **Check cluster status:**
   ```bash
   kubectl cluster-info
   ```

2. **List nodes:**
   ```bash
   kubectl get nodes
   ```

3. **Check system pods:**
   ```bash
   kubectl get pods -n kube-system
   ```

### Optional: Deploy Sample Application

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

## Security Considerations

- **Network Security Group** allows HTTP/HTTPS traffic
- **System-assigned managed identity** for secure authentication
- **Azure Policy** enabled for governance
- **Azure Monitor** for security monitoring
- **Private networking** with dedicated subnet

## Cost Optimization

- **Auto-scaling** reduces costs during low usage
- **Spot instances** can be enabled for additional savings
- **Reserved instances** for predictable workloads
- **Azure Hybrid Benefit** for Windows workloads

## Maintenance

### Upgrading Kubernetes Version

1. Update `kubernetes_version` in `terraform.tfvars`
2. Run `terraform plan` to review changes
3. Run `terraform apply` to upgrade

### Scaling

- **Horizontal scaling:** Modify `node_count` or auto-scaling limits
- **Vertical scaling:** Change `vm_size` for larger/smaller nodes

## Troubleshooting

### Common Issues

1. **Authentication errors:**
   ```bash
   az login
   az account set --subscription <subscription-id>
   ```

2. **Resource group not found:**
   - Ensure the resource group exists or Terraform can create it
   - Check Azure CLI permissions

3. **Network configuration issues:**
   - Verify subnet CIDR ranges don't conflict
   - Check NSG rules

### Useful Commands

```bash
# View cluster details
az aks show --resource-group <rg-name> --name <cluster-name>

# Get cluster credentials
az aks get-credentials --resource-group <rg-name> --name <cluster-name>

# View node pool details
az aks nodepool list --resource-group <rg-name> --cluster-name <cluster-name>

# Check cluster logs
az aks diagnostics collect --resource-group <rg-name> --name <cluster-name>
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning:** This will delete the entire AKS cluster and all associated resources.

## Support

For issues and questions:
- Check Azure AKS documentation
- Review Terraform Azure provider documentation
- Check Azure status page for service issues

## License

This configuration is provided as-is for educational and deployment purposes. 