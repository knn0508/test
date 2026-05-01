locals {
  https_enabled               = var.enable_https
  effective_frontend_hostname = trimspace(var.frontend_hostname) != "" ? trimspace(var.frontend_hostname) : "${replace(azurerm_public_ip.appgw.ip_address, ".", "-")}.sslip.io"
}

resource "azurerm_public_ip" "appgw" {
  name                = "pip-appgw-${var.suffix}"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "main" {
  name                = "appgw-${var.suffix}"
  resource_group_name = var.rg_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.gateway_subnet_id
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = "port-80"
    port = 80
  }

  dynamic "frontend_port" {
    for_each = local.https_enabled ? [1] : []
    content {
      name = "port-443"
      port = 443
    }
  }

  backend_address_pool {
    name         = "pool-frontend"
    ip_addresses = [var.frontend_private_ip]
  }

  backend_address_pool {
    name         = "pool-backend"
    ip_addresses = [var.backend_private_ip]
  }

  backend_address_pool {
    name         = "pool-acme"
    ip_addresses = [var.ops_private_ip]
  }

  backend_http_settings {
    name                  = "http-settings-frontend"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  backend_http_settings {
    name                  = "http-settings-backend"
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    probe_name            = "probe-backend-health"
    request_timeout       = 30
  }

  backend_http_settings {
    name                  = "http-settings-acme"
    cookie_based_affinity = "Disabled"
    port                  = 8089
    protocol              = "Http"
    request_timeout       = 30
  }

  probe {
    name                                      = "probe-backend-health"
    host                                      = "127.0.0.1"
    path                                      = "/api/health"
    protocol                                  = "Http"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = false

    match {
      status_code = ["200-399"]
    }
  }

  dynamic "ssl_certificate" {
    for_each = local.https_enabled ? [1] : []
    content {
      name                = "frontend-tls"
      key_vault_secret_id = var.ssl_certificate_secret_id
    }
  }

  http_listener {
    name                           = "listener-http"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "port-80"
    host_name                      = local.effective_frontend_hostname != "" ? local.effective_frontend_hostname : null
    protocol                       = "Http"
  }

  dynamic "http_listener" {
    for_each = local.https_enabled ? [1] : []
    content {
      name                           = "listener-https"
      frontend_ip_configuration_name = "appgw-frontend-ip"
      frontend_port_name             = "port-443"
      host_name                      = local.effective_frontend_hostname != "" ? local.effective_frontend_hostname : null
      protocol                       = "Https"
      require_sni                    = local.effective_frontend_hostname != ""
      ssl_certificate_name           = "frontend-tls"
    }
  }

  dynamic "redirect_configuration" {
    for_each = local.https_enabled ? [1] : []
    content {
      name                 = "redirect-http-to-https"
      redirect_type        = "Permanent"
      target_listener_name = "listener-https"
      include_path         = true
      include_query_string = true
    }
  }

  dynamic "request_routing_rule" {
    for_each = local.https_enabled ? {
      http_redirect = {
        name                        = "rule-http-redirect"
        rule_type                   = "Basic"
        http_listener_name          = "listener-http"
        redirect_configuration_name = "redirect-http-to-https"
        url_path_map_name           = null
        priority                    = 90
      }
      https_route = {
        name                        = "rule-frontend-https"
        rule_type                   = "PathBasedRouting"
        http_listener_name          = "listener-https"
        redirect_configuration_name = null
        url_path_map_name           = "url-path-map"
        priority                    = 100
      }
    } : {
      http_route = {
        name                        = "rule-frontend"
        rule_type                   = "PathBasedRouting"
        http_listener_name          = "listener-http"
        redirect_configuration_name = null
        url_path_map_name           = "url-path-map"
        priority                    = 100
      }
    }
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      url_path_map_name           = request_routing_rule.value.url_path_map_name
      priority                    = request_routing_rule.value.priority
    }
  }

  url_path_map {
    name                               = "url-path-map"
    default_backend_address_pool_name  = "pool-frontend"
    default_backend_http_settings_name = "http-settings-frontend"

    path_rule {
      name                       = "acme-challenge-rule"
      paths                      = ["/.well-known/acme-challenge/*"]
      backend_address_pool_name  = "pool-acme"
      backend_http_settings_name = "http-settings-acme"
    }

    path_rule {
      name                       = "api-rule"
      paths                      = ["/api/*"]
      backend_address_pool_name  = "pool-backend"
      backend_http_settings_name = "http-settings-backend"
    }
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection"
    rule_set_version = "3.1"
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }
}
