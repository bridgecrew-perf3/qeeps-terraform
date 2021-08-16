output "id" {
  value = azurerm_servicebus_namespace.sb_ns.id
}

output "connection_string" {
  value = azurerm_servicebus_namespace.sb_ns.default_primary_connection_string
  sensitive = true
}
