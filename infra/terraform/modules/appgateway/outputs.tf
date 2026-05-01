output "appgw_public_ip" {
  value = azurerm_public_ip.appgw.ip_address
}

output "appgw_id" {
  value = azurerm_application_gateway.main.id
}

output "appgw_frontend_hostname" {
  value = local.effective_frontend_hostname
}
