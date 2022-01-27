resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  subnet {
    name  = local.aks_subnet_name
    address_prefix = "10.206.0.0/23"
    security_group = ""
  }
}