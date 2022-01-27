locals {
  storage_account_name = lower(format("%s%s%s%s%s", "stor", substr(var.application_name,0,4), substr(var.environment,0,4),substr(var.location,0,4), "001"))
}
