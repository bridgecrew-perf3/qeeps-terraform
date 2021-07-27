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

output "audience" {
    value = azuread_application.application.identifier_uris[0]
}

output "issuer" {
    value = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/"
}
