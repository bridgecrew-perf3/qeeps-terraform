terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

module "rg" {
  source = "../rg"
  location = var.location
  name = "rg-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
}

module "sa" {
  source = "../sa"
  location = var.location
  resource_group = module.rg.name
  name = "sa${var.app_name}${replace(lower(var.location), " ", "")}${var.env}"
  tier = "Standard"
  replication_type = "LRS"
  access_tier = "Hot"
}

module "appsp" {
  source = "../appsp"
  location = var.location
  resource_group = module.rg.name
  name = "appsp-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
}

# module "func" {
#   source = "../func"
#   location = var.location
#   resource_group = module.rg.name
#   name = "func-${var.app_name}-${each.key}-${replace(lower(var.location), " ", "")}-${var.env}"
#   storage_account_name = module.sa.name
#   storage_account_access_key = module.sa.access_key
#   app_service_plan_id = module.appsp.id
#   kv_id = var.kv_id
#   for_each = toset(["access", "forms"])
#   app_configs = zipmap(keys(var.secrets), [for x in keys(var.secrets): format("@Microsoft.KeyVault(SecretUri=${var.kv_url}secrets/${x}/)")])
#   ad_audience = var.ad_audience
#   ad_application_id = var.ad_application_id
#   ad_application_secret = var.ad_application_secret
# }

module "swa" {
  source = "../swa"
  location = var.location
  resource_group = module.rg.name
  name = "swa-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
}
