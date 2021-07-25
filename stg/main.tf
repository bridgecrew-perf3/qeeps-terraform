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

locals {
  secrets = tomap({
    admin_password = var.admin_password
  })
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
}

# module "ad_app" {
#   source = "../modules/ad-app"
#   name = module.dns.name
# }

module "ad_app" {
  source = "../modules/ad-app-fake"
  name = module.dns.name
  application_secret = "-R-YjoQ5hwG_d0Saw704p0hsX0jjxk-qxP"
  application_id = "ce50bd0d-4018-4d43-98e1-bcb373e994ab"
  object_id = "93119cdf-81b5-459c-8ffe-d02b1648695d"
}

module "kv" {
  source = "../modules/kv"
  location = module.rg.location
  resource_group = module.rg.name
  name = "kv-${var.app_name}-${var.env}"
  secrets = local.secrets
}

module "zone" {
  source = "../modules/zone"
  location = "West Europe"
  app_name = var.app_name
  env = var.env
  kv_id = module.kv.id
  kv_url = module.kv.url
  secrets = local.secrets
  ad_application_id = module.ad_app.application_id
  ad_application_secret = module.ad_app.application_secret
  ad_audience = module.ad_app.audience
}
