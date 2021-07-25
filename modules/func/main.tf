terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


resource "azurerm_function_app" "function_app" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  os_type = "linux"
  version = "~3"

  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled = true
    active_directory {
      allowed_audiences = [var.ad_audience]
      client_id = var.ad_application_id
      client_secret = var.ad_application_secret
    }

    
  }

  app_settings = merge(var.app_configs, tomap({
    AzureWebJobsDisableHomepage = "true"
  }))
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = var.kv_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_function_app.function_app.identity[0].principal_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}