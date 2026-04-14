# Test environment specific settings

environment = "test"

# SQL Database settings - slightly larger than dev
sql_database_sku_name = "GP_S_Gen5_2"  # Serverless, 2 vCore
sql_database_max_size_gb = 64
sql_auto_pause_delay_in_minutes = 120  # Auto-pause after 2 hours of inactivity
sql_min_capacity = 0.5  # Minimum compute in vCores

# Storage account settings
storage_account_kind = "StorageV2"
storage_account_enable_https_traffic_only = true

# Environment specific tags
environment_tags = {
  Environment = "Test"
  CostCenter  = "Test"
}
