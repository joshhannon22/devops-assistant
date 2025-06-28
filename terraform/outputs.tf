output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.aks_rg.name
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "kube_config" {
  description = "Kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "host" {
  description = "Kubernetes cluster server host"
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

output "client_certificate" {
  description = "Kubernetes cluster client certificate"
  value       = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  sensitive   = true
}

output "client_key" {
  description = "Kubernetes cluster client key"
  value       = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate"
  value       = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  sensitive   = true
}

output "node_resource_group" {
  description = "Name of the node resource group"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "network_profile" {
  description = "Network profile of the AKS cluster"
  value = {
    network_plugin     = azurerm_kubernetes_cluster.aks.network_profile.0.network_plugin
    network_policy     = azurerm_kubernetes_cluster.aks.network_profile.0.network_policy
    service_cidr       = azurerm_kubernetes_cluster.aks.network_profile.0.service_cidr
    dns_service_ip     = azurerm_kubernetes_cluster.aks.network_profile.0.dns_service_ip
  }
}

output "identity" {
  description = "Identity information of the AKS cluster"
  value = {
    principal_id = azurerm_kubernetes_cluster.aks.identity.0.principal_id
    tenant_id    = azurerm_kubernetes_cluster.aks.identity.0.tenant_id
  }
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = var.enable_azure_monitor ? azurerm_log_analytics_workspace.aks_workspace[0].id : null
} 