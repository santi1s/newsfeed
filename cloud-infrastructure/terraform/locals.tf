locals {
  resource_group_name=join("-", ["rg", var.application_name,var.environment, var.location, ])
}
