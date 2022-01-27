provider "azurerm" {
  features {
    // Without this it wont purge a key vault entry even if soft delete is not enabled
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

provider "azuread" {
  # Configuration options
}