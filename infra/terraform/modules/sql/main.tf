resource "azurerm_mssql_server" "main" {
  name                         = "sql-${var.suffix}"
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"

  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "main" {
  name      = "sqldb-${var.suffix}"
  server_id = azurerm_mssql_server.main.id
  sku_name  = "Basic"
}

resource "azurerm_private_endpoint" "sql" {
  name                = "pep-sql-${var.suffix}"
  resource_group_name = var.rg_name
  location            = var.location
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "psc-sql-${var.suffix}"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "dns-link-sql-${var.suffix}"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "sql" {
  name                = "sql-${var.suffix}"
  zone_name           = azurerm_private_dns_zone.sql.name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql.private_service_connection[0].private_ip_address]
}