output "id" {
    value = azurerm_app_configuration.app_configuration.id
}

output "endpoint" {
    value = azurerm_app_configuration.app_configuration.endpoint
}

output "connection_string" {
    value = azurerm_app_configuration.app_configuration.primary_read_key[0].connection_string
    sensitive = true
}

output "connection_string_secret" {
    value = azurerm_app_configuration.app_configuration.primary_read_key[0].secret
    sensitive = true
}

output "access_key_id" {
    value = azurerm_app_configuration.app_configuration.primary_read_key[0].id
}