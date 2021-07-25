output "id" {
    value = azurerm_function_app.function_app.id
}

output "hostname" {
    value = azurerm_function_app.function_app.default_hostname
}

output "principal_id" {
    value = azurerm_function_app.function_app.identity[0].principal_id
}