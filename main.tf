resource "azurerm_policy_definition" "main" {
  for_each            = var.policy_json
  name                = split(".", each.key)[0]
  display_name        = try(each.value.display_name, "Custom Policy")
  policy_type         = try(each.value.policy_type, "Custom")
  mode                = try(each.value.mode, "All")
  policy_rule         = jsonencode(each.value.properties.policyRule)
  parameters          = jsonencode(each.value.properties.parameters)
  metadata            = jsonencode(each.value.properties.metadata)
  management_group_id = var.management_group_id
}

resource "azurerm_management_group_policy_assignment" "main" {
  for_each             = azurerm_policy_definition.main
  name                 = substr(split(".", each.value.name)[0], 0, 24)
  policy_definition_id = each.value.id
  management_group_id  = var.management_group_id
  depends_on = [
    azurerm_policy_definition.main
  ]
}