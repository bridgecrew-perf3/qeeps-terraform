output "id" {
  value = azurerm_cosmosdb_account.cdb.id
}

output "connection_string" {
  value = azurerm_cosmosdb_account.cdb.connection_strings[0]
  sensitive = true
}

