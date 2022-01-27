output "primary_web_endpoint" {
  description = "The endpoint URL for web storage"
  value       = azurerm_storage_account.static_mvpapp.primary_web_endpoint 
}
