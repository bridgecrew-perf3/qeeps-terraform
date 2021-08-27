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



module "ad_app" {
  source = "../modules/ad-app"
  name = var.domain_name
  redirect_url = "app.${var.domain_name}"
  include_localhost_redirect = true
}

module "graph_ad_sp" {
  source = "../modules/data-ad-sp"
  name = "Microsoft Graph"
  allowed_role_names = [ "User.Read.All", "Group.Read.All" ]
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


module "sa" {
  source           = "../modules/sa"
  location         = module.rg.location
  resource_group   = module.rg.name
  name             = "sa${var.app_name}${var.env}"
  tier             = "Standard"
  replication_type = "LRS"
  access_tier      = "Hot"
  create_containers = true
}

locals {
  secrets = tomap({
    adminpassword = var.adminpassword,
    adapplicationsecret = module.ad_app.application_secret,
    cdbconnectionstring = module.cdb.connection_string,
    publicvapidkey = var.publicvapidkey
    privatevapidkey = var.privatevapidkey,
    sendgridapikey = var.sendgridapikey,
    saconnectionstring = module.sa.connection_string
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
  domain_name = var.app_hostname
  is_main = true
  use_function_proxy = true
}


module "dns" {
  source = "../modules/dns"
  name = var.domain_name
  resource_group = module.rg.name
  cname_value = module.zone.swa_hostname
  cname = "app"
}

module "swa_custom_domain" {
  source = "../modules/swa-custom-domain"
  resource_group = module.rg.name
  swa_name = module.zone.swa_name
  domain = var.app_hostname
}


# module "fd" {
#   source = "../modules/fd"
#   resource_group = module.rg.name
#   name = "fd-${var.app_name}-${var.env}"
#   cname = var.app_hostname
#   health_probe_interval = 120
#   swa_hostnames = [
#     module.zone.swa_hostname
#   ]
#   access_hostnames = [
#     module.zone.access_hostname
#   ]

#   forms_hostnames = [
#     module.zone.forms_hostname
#   ]

#   notifications_hostnames = [
#     module.zone.notifications_hostname
#   ]

#   files_hostnames = [ 
#     module.zone.files_hostname
#    ]

#   depends_on = [
#     module.dns
#   ]

# }
