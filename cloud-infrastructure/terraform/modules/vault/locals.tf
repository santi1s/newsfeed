locals {
  kv_name=substr(join("-", ["kv", var.application_name,var.environment, var.location]),0,24)
}
