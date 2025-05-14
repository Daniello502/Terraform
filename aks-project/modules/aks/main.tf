# Defines the AKS Cluster

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.aks_cluster_name}-dns" # Unique DNS prefix
  sku_tier            = "Free"

  default_node_pool {
    name                 = "systempool" # Default node pool name
    node_count           = var.node_count
    vm_size              = "B2as_v2" # Standard VM size, change if needed
    vnet_subnet_id       = var.aks_subnet_id # Assign the AKS nodes to the correct subnet
    os_disk_size_gb      = 30
    type                 = "System" # Mark as a system node pool
  }

  identity {
    type = "SystemAssigned" # Use System Assigned Managed Identity
  }

  network_profile {
    network_plugin     = "azure" # Use Azure CNI for advanced networking (recommended for production)
    dns_service_ip     = "10.0.0.10" # DNS IP within the VNet (must not overlap with VNet or subnet prefixes)
    docker_bridge_cidr = "172.17.0.1/16" # Docker bridge CIDR
    service_cidr       = "10.0.3.0/24" # Service CIDR within the VNet (must not overlap)
  }

  # Enable monitoring (Optional but recommended)
  addon_profile {
    oms_agent {
      enabled = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
    }
  }

  tags = {
    Environment = "Development" # Example tag
  }
}