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
    redirect_uris = ["https://${var.name}/.auth/login/aad/callback"]
    implicit_grant {
      access_token_issuance_enabled = false
    }
  }

  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access resources on behalf of the signed-in user."
      admin_consent_display_name = "Impersonation"
      enabled                    = true
      id                         = random_uuid()
      type                       = "User"
      user_consent_description   = "Allow the application to access resources on your behalf."
      user_consent_display_name  = "Impersonation"
      value                      = "user_impersonation"
    }
  }

}

resource "azuread_application_password" "application_password" {
  application_object_id = azuread_application.application.object_id
  end_date              = "2038-01-01T00:00:00Z"
}
