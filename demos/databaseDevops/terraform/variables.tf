# General variables
variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "project_name" {
  description = "Short project name"
  type        = string
}

variable "project_full_name" {
  description = "Full project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "environment_tags" {
  description = "Environment specific tags"
  type        = map(string)
  default     = {}
}

# SQL Server variables
variable "sql_server_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "sql_server_admin_login" {
  description = "SQL Server administrator login"
  type        = string
}

variable "sql_server_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

# SQL Database variables
variable "sql_database_sku_name" {
  description = "SQL Database SKU"
  type        = string
}

variable "sql_database_max_size_gb" {
  description = "Maximum size of the database in GB"
  type        = number
}

variable "sql_auto_pause_delay_in_minutes" {
  description = "Auto-pause delay in minutes (-1 to disable)"
  type        = number
  default     = 60
}

variable "sql_min_capacity" {
  description = "Minimum capacity for serverless database"
  type        = number
  default     = 0.5
}

# Storage Account variables
variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "storage_account_kind" {
  description = "Storage account kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_enable_https_traffic_only" {
  description = "Enable HTTPS traffic only"
  type        = bool
  default     = true
}
