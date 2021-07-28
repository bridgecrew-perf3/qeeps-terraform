terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

resource "azuread_application" "application" {
  display_name     = var.name
  identifier_uris  = ["api://${var.name}"]
  sign_in_audience = "AzureADMyOrg"
  app_role_assignment_required = true


  lifecycle {
    ignore_changes = [
      web      
    ]
  }
}

data "azuread_client_config" "current" {}

resource "null_resource" "patch_ad_application" {
  provisioner "local-exec" {
    command = "az rest --method PATCH --uri 'https://graph.microsoft.com/v1.0/applications/${azuread_application.application.object_id}' --headers 'Content-Type=application/json' --body '{\"spa\":{\"redirectUris\":[\"https://${var.name}\"]}}'"
  }
}

resource "azuread_application_password" "application_password" {
  application_object_id = azuread_application.application.object_id
  end_date              = "2038-01-01T00:00:00Z"
}

resource "azuread_group" "qeeps_group" {
  display_name = var.name
  owners = [ azuread_application.application.object_id ]
}
