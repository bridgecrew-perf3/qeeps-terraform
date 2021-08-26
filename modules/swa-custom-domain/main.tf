terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "null_resource" "domain" {
  provisioner "local-exec" {
    command = <<EOF
az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID && az staticwebapp hostname set -n ${var.swa_name} -g ${var.resource_group} --subscription ${data.azurerm_client_config.current.subscription_id} --hostname ${var.domain}
EOF
  }

  triggers = {
    always_run = var.domain
  }
}