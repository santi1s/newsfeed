locals {
  acr_name=format("%s%s%s%s", "acr", var.application_name,var.environment, var.location)
}
