output "keyvault_id" {
  description = "Keyvault generated id"
  value       = azurerm_key_vault.kv.id
}

output "keyvault_uri" {
  description = "The URI of the Key Vault, used for performing operations on keys and secrets"
  value       = azurerm_key_vault.kv.vault_uri
}

