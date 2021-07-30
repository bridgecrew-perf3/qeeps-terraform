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
  cname = "fd-${var.app_name}-${var.env}.azurefd.net"
}

module "ad_app" {
  source = "../modules/ad-app"
  name = module.dns.cname
  includeLocalhostRedirect = true
}

locals {
  secrets = tomap({
    adminpassword = var.adminpassword,
    adapplicationsecret = module.ad_app.application_secret
  })
}

module "kvl" {
  source = "../modules/kvl"
  location = module.rg.location
  resource_group = module.rg.name
  name = "kvl-${var.app_name}-secrets-${var.env}"
  secrets = local.secrets
}

module "zone" {
  source = "../modules/zone"
  location = "West Europe"
  app_name = var.app_name
  env = var.env
  kvl_id = module.kvl.id
  kvl_url = module.kvl.url
  secrets = local.secrets
  ad_application_id = module.ad_app.application_id
  ad_application_secret = module.ad_app.application_secret
  ad_audience = module.ad_app.audience
  ad_issuer = module.ad_app.issuer
}

module "fd" {
  source = "../modules/fd"
  resource_group = module.rg.name
  name = "fd-${var.app_name}-${var.env}"
  cname = module.dns.cname_hostname
  swa_hostnames = [
    module.zone.swa_hostname
  ]
  access_hostnames = [
    module.zone.access_hostname
  ]

  depends_on = [
    module.dns
  ]
}