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
  os_type                    = "linux"
  version                    = "~3"

  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled                       = true
    default_provider              = "AzureActiveDirectory"
    issuer = var.ad_issuer
    token_refresh_extension_hours = 24 * 30
    token_store_enabled           = true
    unauthenticated_client_action = "RedirectToLoginPage"


    active_directory {
      allowed_audiences = [var.ad_audience]
      client_id         = var.ad_application_id
      client_secret     = var.ad_application_secret
    }


  }

  app_settings = merge(var.app_configs, tomap({
    AzureWebJobsDisableHomepage    = "true",
    APPINSIGHTS_INSTRUMENTATIONKEY = "${var.appi_instrumentation_key}",
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet",
    "AZURE_FUNCTIONS_ENVIRONMENT" = var.func_env,
    "ASPNETCORE_ENVIRONMENT" = var.func_env,
    "Hosting:Environment" = var.func_env
    #"FUNCTIONS_WORKER_RUNTIME" = "dotnet-isolated"
    }))
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = var.kvl_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_function_app.function_app.identity[0].principal_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}

module "graph_api_role_assignment" {
  source = "../ad-sp-app-role-assignment"
  principal_id = azurerm_function_app.function_app.identity[0].principal_id
  resource_id = var.graph_api_object_id
  app_role_id = each.key
  msi_id = azurerm_function_app.function_app.identity[0].principal_id
  for_each = toset(var.graph_api_app_roles_ids)
}