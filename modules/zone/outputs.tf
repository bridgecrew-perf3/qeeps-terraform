output "swa_hostname" {
    value = module.swa.hostname
}

output "access_hostname" {
    value = module.func["access"].hostname
}