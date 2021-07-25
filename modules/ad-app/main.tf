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

  web {
    homepage_url  = "https://${var.name}"
    logout_url    = "https://${var.name}/logout"
    redirect_uris = ["https://${var.name}/oauth/callback/microsoft"]

    implicit_grant {
      access_token_issuance_enabled = true
    }
  }
}

resource "azuread_application_password" "application_password" {
  application_object_id = azuread_application.application.object_id
  end_date = "2038-01-01T00:00:00Z"
}