# Basic configuration for AKS deployment
# Modify these values as needed for your environment

resource_group_name = "rg-aks-cluster"
location            = "East US"
cluster_name        = "aks-cluster"
kubernetes_version  = "1.28.0"

# Node configuration
node_count          = 3
vm_size             = "Standard_DS2_v2"
enable_auto_scaling = true
min_count           = 1
max_count           = 5

# Monitoring and policy
enable_azure_policy = true
enable_azure_monitor = true

# Network configuration
network_plugin      = "azure"
network_policy      = "azure"
service_cidr        = "10.0.0.0/16"
dns_service_ip      = "10.0.0.10"

# Tags
tags = {
  Environment = "Development"
  Project     = "AKS Deployment"
  ManagedBy   = "Terraform"
} 