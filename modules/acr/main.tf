terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_redis_cache" "redis" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  redis_configuration {
    aof_backup_enabled              = var.aof_backup
    aof_storage_connection_string_0 = var.sa_connection_string
  }
}
