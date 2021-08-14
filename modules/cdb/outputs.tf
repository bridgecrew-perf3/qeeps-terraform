output "id" {
  value = azurerm_cosmosdb_account.cdb.id
}

output "connection_strings" {
  value = azurerm_cosmosdb_account.cdb.connection_strings
  sensitive = true
}

