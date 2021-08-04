output "event_hub_name" {
  value = azurerm_eventhub.hub.name
}

output "authorization_rule_id" {
  value = azurerm_eventhub_authorization_rule.rule.id
}