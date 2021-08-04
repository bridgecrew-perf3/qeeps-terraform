output "ns_authorization_rule_id" {
  value = azurerm_eventhub_namespace_authorization_rule.nsrule.id
}

output "name" {
  value = azurerm_eventhub_namespace.namespace.name
}