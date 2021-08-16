terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

module "appi" {
  source         = "../appi"
  location       = var.location
  name           = "appi-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  resource_group = var.resource_group
  retention      = 30
}

module "sa" {
  source           = "../sa"
  location         = var.location
  resource_group   = var.resource_group
  name             = "sa${var.app_name}${replace(lower(var.location), " ", "")}${var.env}"
  tier             = "Standard"
  replication_type = "LRS"
  access_tier      = "Hot"
}

module "acr" {
  source         = "../acr"
  location       = var.location
  resource_group = var.resource_group
  name           = "acr-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  sku            = "Basic"
  capacity       = 0
  family         = "C"
  aof_backup = false
  sa_connection_string = null
}

module "sb" {
  source         = "../sb"
  location       = var.location
  resource_group = var.resource_group
  name           = "sb-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  sku            = "Basic"
  capacity       = 0
}

module "kvl" {
  source         = "../kvl"
  location       = var.location
  resource_group = var.resource_group
  name           = "kvl-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  secrets = merge(var.secrets, tomap({
    redisconnectionstring = module.acr.connection_string,
    sbconnectionstring = module.sb.connection_string
  }))
}

module "appsp" {
  source         = "../appsp"
  location       = var.location
  resource_group = var.resource_group
  name           = "appsp-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
}

locals {
  access_roles = [for k, v in var.graph_api_app_roles_ids : "${var.graph_api_object_id},${v}" if k == "Group.Read.All" || k == "User.Read.All"]
}

module "func_access" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-access-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(
    zipmap(keys(var.secrets), [for x in keys(var.secrets) : "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/${x}/)"]),
    tomap({ redisconnectionstring = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/redisconnectionstring/)" }),
    tomap({ adgroupid = var.ad_group_id}),
    tomap({ location = var.location }),
    tomap({ scope = "${var.ad_audience}/.default"})
  )
  ad_audience              = var.ad_audience
  ad_application_id        = var.ad_application_id
  ad_application_secret    = var.ad_application_secret
  ad_issuer                = var.ad_issuer
  appi_instrumentation_key = module.appi.instrumentation_key
  func_env                 = var.env == "stg" ? "Staging" : "Production"

  roles = local.access_roles

  internal_role_id = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}

module "func_forms" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-forms-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(
    zipmap(keys(var.secrets), [for x in keys(var.secrets) : "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/${x}/)"]),
    tomap({ location = var.location }),
    tomap({ sbconnectionstring = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/sbconnectionstring/)" }),
    tomap({ access_url = "https://${module.func_access.hostname}"}),
    tomap({ notifications_url = "https://${module.func_notifications.hostname}"}),
    tomap({ scope = "${var.ad_audience}/.default"})
  )
  ad_audience              = var.ad_audience
  ad_application_id        = var.ad_application_id
  ad_application_secret    = var.ad_application_secret
  ad_issuer                = var.ad_issuer
  appi_instrumentation_key = module.appi.instrumentation_key
  func_env                 = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}

module "func_notifications" {
  source                     = "../func"
  location                   = var.location
  resource_group             = var.resource_group
  name                       = "func-${var.app_name}-notifications-${replace(lower(var.location), " ", "")}-${var.env}"
  storage_account_name       = module.sa.name
  storage_account_access_key = module.sa.access_key
  app_service_plan_id        = module.appsp.id
  kvl_id                     = module.kvl.id
  app_configs = merge(
    zipmap(keys(var.secrets), [for x in keys(var.secrets) : "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/${x}/)"]),
    tomap({ location = var.location }),
    tomap({ sbconnectionstring = "@Microsoft.KeyVault(SecretUri=${module.kvl.url}secrets/sbconnectionstring/)" }),
    tomap({ access_url = "https://${module.func_access.hostname}"}),
    tomap({ scope = "${var.ad_audience}/.default"})
  )
  ad_audience              = var.ad_audience
  ad_application_id        = var.ad_application_id
  ad_application_secret    = var.ad_application_secret
  ad_issuer                = var.ad_issuer
  appi_instrumentation_key = module.appi.instrumentation_key
  func_env                 = var.env == "stg" ? "Staging" : "Production"

  roles = []

  internal_role_id = var.internal_role_id
  ad_application_object_id = var.ad_application_object_id
}

module "swa" {
  source         = "../swa"
  location       = var.location
  resource_group = var.resource_group
  name           = "swa-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  sku_size       = null
  sku_tier       = "Free"
}
