terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

resource "azurerm_static_site" "static_web_app" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  sku_size = var.sku_size
  sku_tier = var.sku_tier
}

locals {
  json = <<EOF
  {"properties": ${var.properties == null ? "" : jsonencode(var.properties)}}
EOF
}

data "azurerm_client_config" "current" {}

resource "null_resource" "app_settings" {
  provisioner "local-exec" {
    command = <<EOF
az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID && az rest --method put --headers "Content-Type=application/json" --uri "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_static_site.static_web_app.resource_group_name}/providers/Microsoft.Web/staticSites/${azurerm_static_site.static_web_app.name}/config/functionappsettings?api-version=2019-12-01-preview" --body '${local.json}'
EOF
  }

  triggers = {
    always_run = jsonencode(var.properties)
  }

  depends_on = [
    azurerm_static_site.static_web_app
  ]
  count = var.properties != null ? 1 : 0
}