terraform {
  backend "azurerm" {
    resource_group_name  = "rg-marsoffice"
    storage_account_name = "samarsoffice"
    container_name       = "tfstates"
    key                  = "qeeps.stg.tfstate"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {

}


module "rg" {
  source = "../modules/rg"
  location = "West Europe"
  name = "rg-${var.app_name}-${var.env}"
}

module "dns" {
  source = "../modules/dns"
  name = var.domain_name
  resource_group = module.rg.name
  cname_value = "fd-${var.app_name}-${var.env}.azurefd.net"
  cname = "app"
}

module "ad_app" {
  source = "../modules/ad-app"
  name = module.dns.name
  redirect_url = module.dns.cname_hostname
  include_localhost_redirect = true
}

module "graph_ad_sp" {
  source = "../modules/data-ad-sp"
  name = "Microsoft Graph"
}


module "cdb" {
  source = "../modules/cdb"
  resource_group = module.rg.name
  name = "cdb-${var.app_name}-${var.env}"
  free = true
  locations = [module.rg.location]
  multi_master = false
  serverless = true
}

locals {
  secrets = tomap({
    adminpassword = var.adminpassword,
    adapplicationsecret = module.ad_app.application_secret,
    cdbconnectionstring = module.cdb.connection_string
  })
}

module "zone" {
  source = "../modules/zone"
  location = "West Europe"
  resource_group = module.rg.name
  app_name = var.app_name
  env = var.env
  secrets = local.secrets
  ad_application_id = module.ad_app.application_id
  ad_application_secret = module.ad_app.application_secret
  ad_audience = module.ad_app.audience
  ad_issuer = module.ad_app.issuer
  graph_api_object_id = module.graph_ad_sp.object_id
  graph_api_app_roles_ids = module.graph_ad_sp.app_roles_ids
  ad_group_id = module.ad_app.group_object_id
  internal_role_id = module.ad_app.internal_role_id
  ad_application_object_id = module.ad_app.sp_object_id
}

module "fd" {
  source = "../modules/fd"
  resource_group = module.rg.name
  name = "fd-${var.app_name}-${var.env}"
  cname = module.dns.cname_hostname
  health_probe_interval = 120
  swa_hostnames = [
    module.zone.swa_hostname
  ]
  access_hostnames = [
    module.zone.access_hostname
  ]

  forms_hostnames = [
    module.zone.forms_hostname
  ]

  notifications_hostnames = [
    module.zone.notifications_hostname
  ]

  depends_on = [
    module.dns
  ]
}
