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

variable "keyvault_sku" {
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string
}