output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "resource_group_location" {
  value = azurerm_resource_group.main.location
}

output "admin_source_cidr" {
  value = var.admin_source_cidr
}

output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "acr_name" {
  value = azurerm_container_registry.main.name
}

output "frontend_private_ip" {
  value = module.vm.frontend_private_ip
}

output "backend_private_ip" {
  value = module.vm.backend_private_ip
}

output "ops_public_ip" {
  value = module.vm.ops_public_ip
}

output "ops_private_ip" {
  value = module.vm.ops_private_ip
}

output "appgw_hostname" {
  value = module.appgateway.appgw_frontend_hostname
}

output "appgw_frontend_origin" {
  value = "${var.appgw_enable_https ? "https" : "http"}://${module.appgateway.appgw_frontend_hostname != "" ? module.appgateway.appgw_frontend_hostname : module.appgateway.appgw_public_ip}"
}

output "appgw_ssl_certificate_name" {
  value = var.appgw_ssl_certificate_name
}

output "sql_server_fqdn" {
  value = module.sql.sql_server_fqdn
}

output "sql_database_name" {
  value = module.sql.sql_database_name
}

output "sql_admin_login" {
  value = module.sql.sql_admin_login
}

output "key_vault_name" {
  value = module.keyvault.key_vault_name
}

output "gateway_subnet_cidr" {
  value = module.networking.gateway_subnet_cidr
}

output "ops_subnet_cidr" {
  value = module.networking.ops_subnet_cidr
}

output "appgw_public_ip" {
  value = module.appgateway.appgw_public_ip
}
