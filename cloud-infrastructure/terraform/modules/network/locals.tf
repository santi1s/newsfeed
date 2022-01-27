locals {
  vnet_name=join("-", ["vnet", var.application_name,var.environment, var.location])
  aks_subnet_name=join("-", ["subnet", var.application_name,"aks",var.environment, var.location])
  pep_subnet_name=join("-", ["subnet", var.application_name,"pep",var.environment, var.location])
}
