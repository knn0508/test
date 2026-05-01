data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.suffix}"
  location = var.location
}

module "networking" {
  source            = "./modules/networking"
  rg_name           = azurerm_resource_group.main.name
  location          = var.location
  suffix            = local.suffix
  admin_source_cidr = var.admin_source_cidr
}

module "vm" {
  source               = "./modules/vm"
  rg_name              = azurerm_resource_group.main.name
  location             = var.location
  suffix               = local.suffix
  frontend_subnet_id   = module.networking.frontend_subnet_id
  backend_subnet_id    = module.networking.backend_subnet_id
  ops_subnet_id        = module.networking.ops_subnet_id
  admin_ssh_public_key = var.admin_ssh_public_key
}

module "sql" {
  source             = "./modules/sql"
  rg_name            = azurerm_resource_group.main.name
  location           = var.location
  suffix             = local.suffix
  data_subnet_id     = module.networking.data_subnet_id
  vnet_id            = module.networking.vnet_id
  sql_admin_password = var.sql_admin_password
}

module "monitoring" {
  source   = "./modules/monitoring"
  rg_name  = azurerm_resource_group.main.name
  location = var.location
  suffix   = local.suffix
}

resource "azurerm_user_assigned_identity" "appgateway" {
  name                = "id-appgw-${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}

module "keyvault" {
  source                            = "./modules/keyvault"
  rg_name                           = azurerm_resource_group.main.name
  location                          = var.location
  suffix                            = local.suffix
  tenant_id                         = data.azurerm_client_config.current.tenant_id
  deployer_object_id                = data.azurerm_client_config.current.object_id
  secret_reader_principal_ids       = [module.vm.backend_principal_id, module.vm.ops_principal_id, azurerm_user_assigned_identity.appgateway.principal_id]
  certificate_manager_principal_ids = [module.vm.ops_principal_id]
  sql_admin_password                = var.sql_admin_password
  sonar_db_password                 = var.sonar_db_password
  app_insights_connection_string    = module.monitoring.app_insights_connection_string
}

resource "azurerm_container_registry" "main" {
  name                = "acrproject2g6"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "frontend_acr_pull" {
  scope                            = azurerm_container_registry.main.id
  role_definition_name             = "AcrPull"
  principal_id                     = module.vm.frontend_principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "backend_acr_pull" {
  scope                            = azurerm_container_registry.main.id
  role_definition_name             = "AcrPull"
  principal_id                     = module.vm.backend_principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "ops_acr_push" {
  scope                            = azurerm_container_registry.main.id
  role_definition_name             = "AcrPush"
  principal_id                     = module.vm.ops_principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}

module "appgateway" {
  source                          = "./modules/appgateway"
  rg_name                         = azurerm_resource_group.main.name
  location                        = var.location
  suffix                          = local.suffix
  gateway_subnet_id               = module.networking.gateway_subnet_id
  frontend_private_ip             = module.vm.frontend_private_ip
  backend_private_ip              = module.vm.backend_private_ip
  ops_private_ip                  = module.vm.ops_private_ip
  user_assigned_identity_id       = azurerm_user_assigned_identity.appgateway.id
  enable_https                    = var.appgw_enable_https
  ssl_certificate_secret_id       = trimspace(var.appgw_ssl_certificate_secret_id) != "" ? trimspace(var.appgw_ssl_certificate_secret_id) : "${module.keyvault.key_vault_uri}secrets/${var.appgw_ssl_certificate_name}/"
  frontend_hostname               = var.appgw_hostname
}
