terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = var.tier
  account_replication_type = var.replication_type
  access_tier              = var.access_tier
  blob_properties {
    change_feed_enabled = true
    versioning_enabled  = true
  }
}

resource "azurerm_storage_container" "user_files_container" {
  for_each              = var.all_locations
  name                  = replace(lower(each.value), " ", "")
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}