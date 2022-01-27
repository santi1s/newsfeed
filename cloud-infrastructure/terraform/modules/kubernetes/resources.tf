data "azurerm_client_config" "current" {
}

resource "azuread_group" "kubernetes_rbac_cluster_admin" {
  display_name = "${var.environment} ${var.location} ${local.aks_name} Cluster Admin"
  security_enabled = true
}

resource "azuread_group" "kubernetes_rbac_view" {
  display_name = "${var.environment} ${var.location} ${local.aks_name} Cluster View"
  security_enabled = true
}



resource "azurerm_kubernetes_cluster" "aks" {
  name                            = local.aks_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  dns_prefix                      = local.aks_name
  kubernetes_version              = var.kubernetes_version
  sku_tier                        = var.aks_sku_tier
  api_server_authorized_ip_ranges = var.private_cluster_enabled ? null : var.api_server_authorized_ip_ranges
  node_resource_group             = var.node_resource_group
  enable_pod_security_policy      = var.enable_pod_security_policy

  private_cluster_enabled = var.private_cluster_enabled
 
  default_node_pool {
    name                = local.default_node_pool.name
    node_count          = local.default_node_pool.count
    vm_size             = local.default_node_pool.vm_size
    availability_zones  = local.default_node_pool.availability_zones
    enable_auto_scaling = local.default_node_pool.enable_auto_scaling
    min_count           = local.default_node_pool.min_count
    max_count           = local.default_node_pool.max_count
    max_pods            = local.default_node_pool.max_pods
    os_disk_type        = local.default_node_pool.os_disk_type
    os_disk_size_gb     = local.default_node_pool.os_disk_size_gb
    type                = local.default_node_pool.type
    vnet_subnet_id      = local.default_node_pool.vnet_subnet_id
    node_taints         = local.default_node_pool.node_taints
  }

  identity {
    type = "SystemAssigned"
  }


  addon_profile {
    oms_agent {
      enabled                    = var.addons.oms_agent
      log_analytics_workspace_id = var.addons.oms_agent_workspace_id
    }

    kube_dashboard {
      enabled = var.addons.dashboard
    }

    azure_policy {
      enabled = var.addons.policy
    }

    azure_keyvault_secrets_provider {
      enabled = var.addons.azure_keyvault_secrets_provider
      secret_rotation_enabled = var.addons.secret_rotation_enabled
      secret_rotation_interval = var.addons.secret_rotation_interval
    }

  }

  dynamic "linux_profile" {
    for_each = var.linux_profile != null ? [true] : []
    iterator = lp
    content {
      admin_username = var.linux_profile.username

      ssh_key {
        key_data = var.linux_profile.ssh_key
      }
    }
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = cidrhost(var.service_cidr, 10)
    docker_bridge_cidr = var.docker_bridge_cidr
    service_cidr       = var.service_cidr
    load_balancer_sku  = "standard"
    outbound_type      = var.outbound_type

  }

  role_based_access_control {
    azure_active_directory {
      managed = true
      tenant_id = data.azurerm_client_config.current.tenant_id 
      admin_group_object_ids = [ azuread_group.kubernetes_rbac_cluster_admin.id ]
      azure_rbac_enabled = false
    }
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  count                 = length(local.nodes_pools)
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = local.nodes_pools[count.index].name
  vm_size               = local.nodes_pools[count.index].vm_size
  os_type               = local.nodes_pools[count.index].os_type
  os_disk_type          = local.nodes_pools[count.index].os_disk_type
  os_disk_size_gb       = local.nodes_pools[count.index].os_disk_size_gb
  vnet_subnet_id        = local.nodes_pools[count.index].vnet_subnet_id
  enable_auto_scaling   = local.nodes_pools[count.index].enable_auto_scaling
  node_count            = local.nodes_pools[count.index].count
  min_count             = local.nodes_pools[count.index].min_count
  max_count             = local.nodes_pools[count.index].max_count
  max_pods              = local.nodes_pools[count.index].max_pods
  enable_node_public_ip = local.nodes_pools[count.index].enable_node_public_ip
  availability_zones    = local.nodes_pools[count.index].availability_zones

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}
