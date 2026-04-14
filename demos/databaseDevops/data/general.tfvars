# General infrastructure settings for all environments
# Cats of the World (COTW) Project

# Azure region
location = "UK South"

# Project naming
project_name = "cotw"
project_full_name = "catsoftheworld"

# Tags applied to all resources
common_tags = {
  Project     = "CatsOfTheWorld"
  ManagedBy   = "Terraform"
  Repository  = "dbatools-githubactions"
  Owner       = "DatabaseTeam"
}

# SQL Server settings
sql_server_version = "12.0"
sql_server_admin_login = "sqladmin"

# Storage account settings
storage_account_tier = "Standard"
storage_account_replication_type = "LRS"
