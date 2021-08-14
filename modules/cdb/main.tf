terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_cosmosdb_account" "cdb" {
  name                = var.name
  location            = var.locations[0]
  resource_group_name = var.resource_group
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  enable_automatic_failover = true
  enable_multiple_write_locations = var.multi_master
  enable_free_tier = var.free

  dynamic capabilities {
    for_each = var.serverless ? ["1"] : []
    content {
      name = "EnableServerless"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  consistency_policy {
    consistency_level       = "Strong"
  }

  dynamic geo_location {
    for_each = var.locations
    content {
      failover_priority = geo_location.key
      location = geo_location.value
    }
  }
}