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

variable "account_tier" {
  description = "Tier to use for this storage account"
  type        = string
}

variable "account_replication_type" {
  description = "ype of replication to use for this storage account"
  type        = string
}