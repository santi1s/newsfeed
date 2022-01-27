variable "environment" {
  description = "Environment to deploy to"
}

variable "application_name" {
  description = "Application  to deploy"
}

variable "location" {
  description = "Deployment location"
}

variable "vnet_address_space" {
  description = "VNET address spaces to use"
}

variable "static_account_tier" {
  description = "Storage account Tier"
}

variable "static_account_replication_type" {
  description = "Storage account Replication Type"
}

variable "keyvault_sku" {
  description = "Keyvault SKU"
}


variable "newsfeed_token" {
  description = "Token for newsfeed service"
  sensitive = true
}



