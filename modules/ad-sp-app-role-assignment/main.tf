terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
}

locals {
  json = <<EOF
{
  "principalId": "${var.principal_id}",
  "resourceId": "${var.resource_id}",
  "appRoleId": "${var.app_role_id}"
}
EOF
}

resource "null_resource" "app_role_assignment" {
  provisioner "local-exec" {
    command = "az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID && az rest --method POST --uri 'https://graph.microsoft.com/v1.0/servicePrincipals/${var.msi_id}/appRoleAssignments' --headers 'Content-Type=application/json' --body '${local.json}' || true"
  }
}