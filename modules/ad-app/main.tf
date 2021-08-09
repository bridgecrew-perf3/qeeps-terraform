terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

resource "azuread_application" "application" {
  display_name     = var.name
  identifier_uris  = ["api://${var.name}"]
  sign_in_audience = "AzureADMyOrg"
  group_membership_claims = "SecurityGroup"
  

  lifecycle {
    ignore_changes = [
      web      
    ]
  }
optional_claims {
    access_token {
      name                  = "groups"
      source                = null
      essential             = false
      additional_properties = []
    }
    id_token {
      name                  = "groups"
      source                = null
      essential             = false
      additional_properties = []
    }
  }
  app_role {
    allowed_member_types = ["User"]
    description          = "Owner qeeps role"
    display_name         = "Owner"
    enabled           = true
    value                = "Owner"
  }
  app_role {
    allowed_member_types = ["User"]
    description          = "Admin qeeps role"
    display_name         = "Admin"
    enabled           = true
    value                = "Admin"
  }
  app_role {
    allowed_member_types = ["User"]
    description          = "Moderator qeeps role"
    display_name         = "Moderator"
    enabled           = true
    value                = "Moderator"
  }
  app_role {
    allowed_member_types = ["User"]
    description          = "Regular qeeps role"
    display_name         = "Regular"
    enabled           = true
    value                = "Regular"
  }
}

resource "azuread_service_principal" "enterprise_app" {
  application_id                = azuread_application.application.application_id
  app_role_assignment_required = true
}

data "azuread_client_config" "current" {}

locals {
  localhostAddress = var.include_localhost_redirect == true ? ",\"http://localhost:4200\"" : ""
}

resource "null_resource" "patch_ad_application_spa" {
  provisioner "local-exec" {
    command = "az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID && az rest --method PATCH --uri 'https://graph.microsoft.com/v1.0/applications/${azuread_application.application.object_id}' --headers 'Content-Type=application/json' --body '{\"spa\":{\"redirectUris\":[\"${var.redirect_url}\"${local.localhostAddress}]}}'"
  }
}

resource "azuread_application_password" "application_password" {
  application_object_id = azuread_application.application.object_id
  end_date              = "2038-01-01T00:00:00Z"
}

resource "azuread_group" "qeeps_group" {
  display_name = var.name
}
