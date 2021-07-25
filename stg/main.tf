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
  }
}

provider "azurerm" {
  features {}
}

locals {
  secrets = tomap({
    adminPassword = var.adminPassword
  })
}


module "rg" {
  source = "../modules/rg"
  location = "West Europe"
  name = "rg-${var.app_name}-${var.env}"
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
}
