terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_signalr_service" "signalr" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group

  sku {
    name     = var.sku
    capacity = var.capacity
  }

  cors {
    allowed_origins = var.allow_localhost ? ["http://localhost:4200", var.allowed_host] : [var.allowed_host]
  }

  features {
    flag  = "ServiceMode"
    value = "Serverless"
  }
}