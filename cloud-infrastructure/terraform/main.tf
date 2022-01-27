#------------------------------------------------------------------------------
# data sources
#------------------------------------------------------------------------------

data "azurerm_client_config" "current" {
}

#------------------------------------------------------------------------------
# resource group
#------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location

  lifecycle {
    ignore_changes = [tags]
  }
}

module "azure_virtual_network" {
  source  = "./modules/network"

  environment    = var.environment
  location       = azurerm_resource_group.rg.location
  application_name = var.application_name
  resource_group_name = local.resource_group_name

  vnet_address_space   = var.vnet_address_space
}

module "azure_registry" {

  source = "./modules/registry"

  environment = var.environment
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_name    = var.application_name
}



module "azure_kubernetes_service" {
  source  = "./modules/kubernetes"

  environment = var.environment
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_name    = var.application_name
  
  service_cidr       = "10.0.16.0/22"
  kubernetes_version = "1.21.7"

  vnet_id         = module.azure_virtual_network.virtual_network_id
  nodes_subnet_id = module.azure_virtual_network.aks_subnet_id
  nodes_pools = []

  addons = {
    dashboard              = false
    oms_agent              = false
    oms_agent_workspace_id = null
    policy                 = false
    azure_keyvault_secrets_provider = true
    secret_rotation_enabled = false
    secret_rotation_interval = null
  }
}

resource "azurerm_role_assignment" "aks_acr_pull_allowed" {

  principal_id         = module.azure_kubernetes_service.aks_user_managed_identity[0].object_id 
  scope                = module.azure_registry.acr_id
  role_definition_name = "AcrPull"

  depends_on = [
     module.azure_kubernetes_service,
     module.azure_registry
  ]
}


module "azure_storage_account" {

  source = "./modules/storage"

  environment = var.environment
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_name    = var.application_name
  account_tier             = var.static_account_tier
  account_replication_type = var.static_account_replication_type
}

module "azure_keyvault" {

  source = "./modules/vault"

  environment         = var.environment
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_name    = var.application_name
  keyvault_sku        = var.keyvault_sku
}

resource "azurerm_key_vault_secret" "newsfeed" {
  name         = "NEWSFEED-TOKEN"
  value        = var.newsfeed_token
  key_vault_id = module.azure_keyvault.keyvault_id
}

resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id = module.azure_keyvault.keyvault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.azure_kubernetes_service.aks_user_managed_identity[0].object_id 

  key_permissions = ["get"]
  
  certificate_permissions = ["get"]

  secret_permissions = ["get"]
}