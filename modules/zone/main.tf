terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

module "rg" {
  source   = "../rg"
  location = var.location
  name     = "rg-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
}

module "appi" {
  source = "../appi"
  location = var.location
  name = "appi-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  resource_group = module.rg.name
  retention = 30
}

module "sa" {
  source           = "../sa"
  location         = var.location
  resource_group   = module.rg.name
  name             = "sa${var.app_name}${replace(lower(var.location), " ", "")}${var.env}"
  tier             = "Standard"
  replication_type = "LRS"
  access_tier      = "Hot"
}

module "appsp" {
  source         = "../appsp"
  location       = var.location
  resource_group = module.rg.name
  name           = "appsp-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
}

locals {
  group_roles_ids = [ for k, v in var.graph_api_app_roles_ids : v if k == "Group.Read.All" ]
}

module "func_access" {
  source                     = "../func"
  location                   = var.location
  resource_group             = module.rg.name
  name                       = "func-${var.app_name}-access-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                      = var.kvl_id
  app_configs = merge(
    zipmap(keys(var.secrets), [for x in keys(var.secrets) : format("@Microsoft.KeyVault(SecretUri=${var.kvl_url}secrets/${x}/)")]),
    tomap({ adapplicationid = var.ad_application_id, adapplicationaudience = var.ad_audience })
  )
  ad_audience           = var.ad_audience
  ad_application_id     = var.ad_application_id
  ad_application_secret = var.ad_application_secret
  ad_issuer = var.ad_issuer
  appi_instrumentation_key = module.appi.instrumentation_key
  func_env = var.env == "stg" ? "Staging" : "Production"

  graph_api_object_id = var.graph_api_object_id
  graph_api_app_roles_ids = local.group_roles_ids
}

module "func_forms" {
  source                     = "../func"
  location                   = var.location
  resource_group             = module.rg.name
  name                       = "func-${var.app_name}-forms-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                      = var.kvl_id
  app_configs = merge(
    zipmap(keys(var.secrets), [for x in keys(var.secrets) : format("@Microsoft.KeyVault(SecretUri=${var.kvl_url}secrets/${x}/)")]),
    tomap({})
  )
  ad_audience           = var.ad_audience
  ad_application_id     = var.ad_application_id
  ad_application_secret = var.ad_application_secret
  ad_issuer = var.ad_issuer
  appi_instrumentation_key = module.appi.instrumentation_key
  func_env = var.env == "stg" ? "Staging" : "Production"

  graph_api_object_id = var.graph_api_object_id
  graph_api_app_roles_ids = []
}

module "swa" {
  source         = "../swa"
  location       = var.location
  resource_group = module.rg.name
  name           = "swa-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  sku_size = null
  sku_tier = "Free"
}
