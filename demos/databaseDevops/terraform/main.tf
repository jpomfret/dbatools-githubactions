# Generate random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Merge tags
locals {
  all_tags = merge(
    var.common_tags,
    var.environment_tags
  )

  # Azure naming convention: rg-{project}-{environment}-{region}
  resource_group_name = "rg-${var.project_name}-${var.environment}-${replace(lower(var.location), " ", "")}"

  # Azure naming convention: sql-{project}-{environment}-{region}
  sql_server_name = "sql-${var.project_name}-${var.environment}-${random_string.suffix.result}"

  # Azure naming convention: sqldb-{project}-{environment}
  sql_database_name = "sqldb-${var.project_name}-${var.environment}"

  # Azure naming convention: st{project}{environment}{suffix} (no hyphens, max 24 chars)
  storage_account_name = "st${var.project_full_name}${var.environment}${random_string.suffix.result}"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.all_tags
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                       = local.storage_account_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  account_tier               = var.storage_account_tier
  account_replication_type   = var.storage_account_replication_type
  account_kind               = var.storage_account_kind
  https_traffic_only_enabled = var.storage_account_enable_https_traffic_only

  tags = local.all_tags
}

# SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = local.sql_server_name
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = var.sql_server_version
  administrator_login          = var.sql_server_admin_login
  administrator_login_password = var.sql_server_admin_password
  minimum_tls_version          = "1.2"

  tags = local.all_tags
}

# SQL Database - Serverless
resource "azurerm_mssql_database" "main" {
  name           = local.sql_database_name
  server_id      = azurerm_mssql_server.main.id
  sku_name       = var.sql_database_sku_name
  max_size_gb    = var.sql_database_max_size_gb
  zone_redundant = false

  auto_pause_delay_in_minutes = var.sql_auto_pause_delay_in_minutes
  min_capacity                = var.sql_min_capacity

  tags = local.all_tags
}

# Firewall rule to allow Azure services
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
