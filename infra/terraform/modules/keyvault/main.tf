locals {
  compact_suffix                     = replace(var.suffix, "-", "")
  access_policy_principal_ids        = merge(var.secret_reader_principal_ids, var.certificate_manager_principal_ids)
  certificate_manager_principal_keys = keys(var.certificate_manager_principal_ids)
  secret_reader_permissions = [
    "Get",
    "List",
  ]
  certificate_manager_secret_permissions = [
    "Delete",
    "Get",
    "List",
    "Set",
  ]
  certificate_manager_permissions = [
    "Create",
    "Delete",
    "Get",
    "Import",
    "List",
    "Update",
  ]
}

resource "azurerm_key_vault" "main" {
  name                          = "kv${local.compact_suffix}"
  location                      = var.location
  resource_group_name           = var.rg_name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  public_network_access_enabled = true
}

resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = var.deployer_object_id

  secret_permissions = [
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Set",
  ]
}

resource "azurerm_key_vault_access_policy" "secret_readers" {
  for_each = local.access_policy_principal_ids

  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = each.value

  secret_permissions      = contains(local.certificate_manager_principal_keys, each.key) ? local.certificate_manager_secret_permissions : local.secret_reader_permissions
  certificate_permissions = contains(local.certificate_manager_principal_keys, each.key) ? local.certificate_manager_permissions : null
}

moved {
  from = azurerm_key_vault_access_policy.certificate_managers["ops"]
  to   = azurerm_key_vault_access_policy.secret_readers["ops"]
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = var.sql_admin_password
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.deployer]
}

resource "azurerm_key_vault_secret" "sonar_db_password" {
  name         = "sonar-db-password"
  value        = var.sonar_db_password
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.deployer]
}

resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  name         = "applicationinsights-connection-string"
  value        = var.app_insights_connection_string
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.deployer]
}
