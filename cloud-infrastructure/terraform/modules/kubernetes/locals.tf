locals {
  aks_name=join("-", ["aks", var.application_name,var.environment, var.location])
  aks_user_assigned_identity_name   = "aks-${var.application_name}-${var.location}-${var.environment}-identity"

  default_agent_profile = {
    name                  = "default"
    count                 = 1
    vm_size               = "Standard_D2_v3"
    os_type               = "Linux"
    availability_zones    = [1, 2, 3]
    enable_auto_scaling   = false
    min_count             = null
    max_count             = null
    type                  = "VirtualMachineScaleSets"
    node_taints           = null
    vnet_subnet_id        = var.nodes_subnet_id
    max_pods              = 30
    os_disk_type          = "Managed"
    os_disk_size_gb       = 30
    enable_node_public_ip = false
  }

  default_linux_node_profile = {
    max_pods        = 30
    os_disk_size_gb = 128
  }

  default_node_pool = merge(local.default_agent_profile, var.default_node_pool)

  nodes_pools_with_defaults = [for ap in var.nodes_pools : merge(local.default_agent_profile, ap)]
  nodes_pools               = [for ap in local.nodes_pools_with_defaults : merge(local.default_linux_node_profile, ap)]
}
