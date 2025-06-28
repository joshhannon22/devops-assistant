# Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Log Analytics Workspace for Azure Monitor
resource "azurerm_log_analytics_workspace" "aks_workspace" {
  count               = var.enable_azure_monitor ? 1 : 0
  name                = "law-${var.cluster_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  default_node_pool {
    name                = "default"
    node_count          = var.enable_auto_scaling ? null : var.node_count
    vm_size             = var.vm_size
    os_disk_size_gb     = 128
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    min_count           = var.enable_auto_scaling ? var.min_count : null
    max_count           = var.enable_auto_scaling ? var.max_count : null
    max_pods            = 110
    type                = "VirtualMachineScaleSets"
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
  }

  # Azure Policy
  azure_policy_enabled = var.enable_azure_policy

  # Azure Monitor
  dynamic "oms_agent" {
    for_each = var.enable_azure_monitor ? [1] : []
    content {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_workspace[0].id
    }
  }

  # Identity
  identity {
    type = "SystemAssigned"
  }

  # Auto-upgrade channel
  auto_scaler_profile {
    scale_down_delay_after_add = "15m"
    scale_down_unneeded        = "15m"
  }

  # Maintenance window
  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [0, 1, 2, 3, 4, 5, 6]
    }
  }
}

# Azure Container Registry (optional - uncomment if needed)
# resource "azurerm_container_registry" "acr" {
#   name                = "acr${replace(var.cluster_name, "-", "")}"
#   resource_group_name = azurerm_resource_group.aks_rg.name
#   location            = var.location
#   sku                 = "Standard"
#   admin_enabled       = true
#   tags                = var.tags
# }

# ACR integration with AKS (uncomment if using ACR)
# resource "azurerm_role_assignment" "aks_acr" {
#   principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
#   role_definition_name             = "AcrPull"
#   scope                            = azurerm_container_registry.acr.id
#   skip_service_principal_aad_check = true
# } 