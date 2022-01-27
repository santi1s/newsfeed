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

variable "vnet_address_space" {
  description = "The address space(s) that is used by the virtual network"
  type        = list(string)
}