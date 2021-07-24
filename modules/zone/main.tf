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

module "kv" {
  source = "../kv"
  location = var.location
  resourceGroup = module.rg.name
  name = "kv-${var.app_name}-${replace(lower(var.location), " ", "")}-${var.env}"
  secrets = var.secrets
}
