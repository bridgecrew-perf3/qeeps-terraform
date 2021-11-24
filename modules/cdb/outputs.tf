output "id" {
  value = azurerm_cosmosdb_account.cdb.id
}

output "connection_string" {
  value     = azurerm_cosmosdb_account.cdb.connection_strings[0]
  sensitive = true
}

output "multi_master" {
  value = azurerm_cosmosdb_account.cdb.enable_multiple_write_locations
}
