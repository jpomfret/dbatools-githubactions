# Production environment specific settings

environment = "prod"

# SQL Database settings - production sizing
sql_database_sku_name = "GP_S_Gen5_4"  # Serverless, 4 vCore
sql_database_max_size_gb = 128
sql_auto_pause_delay_in_minutes = -1  # Disable auto-pause for production
sql_min_capacity = 1.0  # Minimum compute in vCores

# Storage account settings
storage_account_kind = "StorageV2"
storage_account_enable_https_traffic_only = true

# Environment specific tags
environment_tags = {
  Environment = "Production"
  CostCenter  = "Production"
}
