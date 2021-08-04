terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azuread"
    }
  }
}

data "azuread_service_principal" "sp" {
  display_name = var.name
}

locals {
  ids = [for v in data.azuread_service_principal.sp.app_roles : v.id]
  keys = [for v in data.azuread_service_principal.sp.app_roles : v.value]
}