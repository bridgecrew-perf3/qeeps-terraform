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
