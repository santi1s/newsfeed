
resource "azurerm_storage_account" "static_mvpapp" {
  name                     = local.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  enable_https_traffic_only = true

  static_website {
    index_document = "bootstrap.min.css"
  }
}