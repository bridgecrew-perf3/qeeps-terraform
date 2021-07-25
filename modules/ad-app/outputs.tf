output "application_id" {
    value = azuread_application.application.application_id
}

output "object_id" {
    value = azuread_application.application.object_id
}

output "application_secret" {
    value = azuread_application_password.application_password.value
    sensitive = true
}