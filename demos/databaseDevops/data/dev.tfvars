# Development environment specific settings

environment = "dev"

# SQL Database settings - minimal for dev
sql_database_sku_name = "GP_S_Gen5_1"  # Serverless, 1 vCore
sql_database_max_size_gb = 32
sql_auto_pause_delay_in_minutes = 60  # Auto-pause after 1 hour of inactivity
sql_min_capacity = 0.5  # Minimum compute in vCores

# Storage account settings
storage_account_kind = "StorageV2"
storage_account_enable_https_traffic_only = true

# Environment specific tags
environment_tags = {
  Environment = "Development"
  CostCenter  = "Dev"
}
