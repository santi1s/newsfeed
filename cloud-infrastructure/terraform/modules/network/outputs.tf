output "virtual_network_id" {
  description = "Virtual network generated id"
  value       = azurerm_virtual_network.vnet.id
}

output "virtual_network_location" {
  description = "Virtual network location"
  value       = azurerm_virtual_network.vnet.location
}

output "virtual_network_name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.vnet.name
}

output "virtual_network_space" {
  description = "Virtual network space"
  value       = azurerm_virtual_network.vnet.address_space
}

output "aks_subnet_id" {
  description = "AKS nodepool subnet ID"
  value       = azurerm_virtual_network.vnet.subnet.*.id[0]
}
