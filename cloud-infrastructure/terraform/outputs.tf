output "acr_fqdn" {
  description = "The Container Registry FQDN."
  value       = module.azure_registry.login_server
}

output "aks_kube_admin_config" {
  description = "Kube configuration of AKS Cluster"
  value       = module.azure_kubernetes_service.aks_kube_admin_config
  sensitive   = true
}

output "aks_client_id" {
  value       = module.azure_kubernetes_service.aks_user_managed_identity[0].client_id
  description = "The AKS Kubelet client id"
  sensitive   = true
}