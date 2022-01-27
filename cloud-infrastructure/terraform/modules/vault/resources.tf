
data "azurerm_client_config" "current" {
}


resource "azurerm_key_vault" "kv" {
  name                = local.kv_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.keyvault_sku
}

resource "azurerm_key_vault_access_policy" "terraformclient" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = []

  certificate_permissions = [
    "list",
    "import",
    "get",
    "delete"
  ]

  secret_permissions = [
    "list",
    "set",
    "get",
    "delete"
  ]
}