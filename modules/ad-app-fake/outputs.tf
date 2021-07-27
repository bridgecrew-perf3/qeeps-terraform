output "application_id" {
    value = var.application_id
}

output "object_id" {
    value = var.object_id
}

output "application_secret" {
    value = var.application_secret
    sensitive = true
}

output "audience" {
    value = "api://${var.name}"
}

output "issuer" {
    value = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/"
}