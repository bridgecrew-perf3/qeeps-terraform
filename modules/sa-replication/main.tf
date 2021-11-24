terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_storage_object_replication" "replication" {
  source_storage_account_id      = var.src_id
  destination_storage_account_id = var.dest_id
  rules {
    source_container_name        = var.container
    destination_container_name   = var.container
    filter_out_blobs_with_prefix = var.prefix == null ? null : [var.prefix]
    copy_blobs_created_after     = "Everything"
  }
}
