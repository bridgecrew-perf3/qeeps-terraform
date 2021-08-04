output "event_hub_name" {
  value = azurerm_eventhub.hub.name
}

output "ns_authorization_rule_id" {
  value = azurerm_eventhub_namespace_authorization_rule.nsrule.id
}