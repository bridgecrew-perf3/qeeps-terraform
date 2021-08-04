terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_monitor_aad_diagnostic_setting" "rule" {
  name               = var.name
  eventhub_name = var.event_hub_name
  eventhub_authorization_rule_id = var.event_hub_ns_authorization_rule_id
  log {
    category = "AuditLogs"
    enabled  = true
    retention_policy {}
  }
}