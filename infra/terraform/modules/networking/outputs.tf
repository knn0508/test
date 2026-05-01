output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}

output "gateway_subnet_cidr" {
  value = azurerm_subnet.gateway.address_prefixes[0]
}

output "frontend_subnet_id" {
  value = azurerm_subnet.frontend.id
}

output "backend_subnet_id" {
  value = azurerm_subnet.backend.id
}

output "data_subnet_id" {
  value = azurerm_subnet.data.id
}

output "ops_subnet_id" {
  value = azurerm_subnet.ops.id
}

output "ops_subnet_cidr" {
  value = azurerm_subnet.ops.address_prefixes[0]
}
