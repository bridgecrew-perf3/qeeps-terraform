output "object_id" {
    value = data.azuread_service_principal.sp.object_id
}

output "application_id" {
    value = data.azuread_service_principal.sp.application_id
}


output "app_roles_ids" {
    value = zipmap(local.keys, local.ids)
}