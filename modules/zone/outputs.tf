output "swa_name" {
  value = module.swa.name
}

output "swa_hostname" {
  value = module.swa.hostname
}

output "access_hostname" {
  value = module.func_access.hostname
}

output "forms_hostname" {
  value = module.func_forms.hostname
}

output "notifications_hostname" {
  value = module.func_notifications.hostname
}

output "files_hostname" {
  value = module.func_files.hostname
}

output "sa" {
  value = module.sa
}
