variable "environment" {
  description = "Environmnt to deploy to"
  type        = string
}

variable "application_name" {
  description = "Application  to deploy"
  type        = string
}

variable "location" {
  description = "Deployment location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}


variable "kubernetes_version" {
  description = "Version of Kubernetes to deploy"
  type        = string
  default     = "1.21.7"
}

variable "api_server_authorized_ip_ranges" {
  description = "Ip ranges allowed to interract with Kubernetes API. Default no restrictions"
  type        = list(string)
  default     = []
}

variable "node_resource_group" {
  description = "Name of the resource group in which to put AKS nodes. If null default to MC_<AKS RG Name>"
  type        = string
  default     = null
}

variable "enable_pod_security_policy" {
  description = "Enable pod security policy or not. https://docs.microsoft.com/fr-fr/azure/AKS/use-pod-security-policies"
  type        = bool
  default     = false
}

variable "private_cluster_enabled" {
  description = "Configure AKS as a Private Cluster : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#private_cluster_enabled"
  type        = bool
  default     = false
}

variable "vnet_id" {
  description = "Vnet id that Aks MSI should be network contributor in a private cluster"
  type        = string
  default     = null
}


variable "aks_user_assigned_identity_resource_group_name" {
  description = "Resource Group where to deploy the aks user assigned identity resource. Used when private cluster is enabled and when Azure private dns zone is not managed by aks"
  type        = string
  default     = null
}

variable "aks_user_assigned_identity_custom_name" {
  description = "Custom name for the aks user assigned identity resource"
  type        = string
  default     = null
}

variable "aks_sku_tier" {
  description = "aks sku tier. Possible values are Free ou Paid"
  type        = string
  default     = "Free"
}

variable "default_node_pool" {
  description = <<EOD
Default node pool configuration:

```
map(object({
    name                  = string
    count                 = number
    vm_size               = string
    os_type               = string
    availability_zones    = list(number)
    enable_auto_scaling   = bool
    min_count             = number
    max_count             = number
    type                  = string
    node_taints           = list(string)
    vnet_subnet_id        = string
    max_pods              = number
    os_disk_type          = string
    os_disk_size_gb       = number
    enable_node_public_ip = bool
}))
```
EOD

  type    = map(any)
  default = {}
}

variable "nodes_subnet_id" {
  description = "Id of the subnet used for nodes"
  type        = string
}

variable "addons" {
  description = "Kubernetes addons to enable /disable"
  type = object({
    dashboard              = bool,
    oms_agent              = bool,
    oms_agent_workspace_id = string,
    policy                 = bool,
    azure_keyvault_secrets_provider = bool,
    secret_rotation_enabled = bool,
    secret_rotation_interval = string,
  })
  default = {
    dashboard              = false,
    oms_agent              = true,
    oms_agent_workspace_id = null,
    policy                 = false,
    azure_keyvault_secrets_provider = true
    secret_rotation_enabled = false,
    secret_rotation_interval = null,
  }
}

variable "linux_profile" {
  description = "Username and ssh key for accessing AKS Linux nodes with ssh."
  type = object({
    username = string,
    ssh_key  = string
  })
  default = null
}

variable "service_cidr" {
  description = "CIDR used by kubernetes services (kubectl get svc)."
  type        = string
}

variable "outbound_type" {
  description = "The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are `loadBalancer` and `userDefinedRouting`."
  type        = string
  default     = "loadBalancer"
}

variable "docker_bridge_cidr" {
  description = "IP address for docker with Network CIDR."
  type        = string
  default     = "172.16.0.1/16"
}

variable "nodes_pools" {
  description = "A list of nodes pools to create, each item supports same properties as `local.default_agent_profile`"
  type        = list(any)
}

##########################
# ArgoCD variables
##########################


variable "argocd_chart_repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argocd_chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "3.31.0"
}

variable "argocd_settings" {
  description = <<EODK
Settings for argocd helm chart go here <br />
<pre>
map(object({ <br />
  nameOverride                               = string <br />
  fullnameOverride                           = string <br />
  kubeVersionOverride                        = string <br />
  global.networkPolicy.create                = string <br />
  global.networkPolicy.defaultDenyIngress    = string <br />
}))<br />
</pre>
EODK
  type        = map(string)
  default     = {}
}