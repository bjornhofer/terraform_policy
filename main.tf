
provider "azurerm" {
  features {}
  alias = "policy"
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id
} 

resource "azurerm_policy_definition" "main" {
  for_each            = { for policy in fileset("${path.module}/policies", "*.json") : policy => jsondecode(file("${path.module}/policies/${policy}")) }
  name                = "${var.base_name}_${split(".", each.key)[0]}"
  display_name        = try(each.value.display_name, "Custom Policy")
  policy_type         = try(each.value.policy_type, "Custom")
  mode                = try(each.value.mode, "All")
  policy_rule         = jsonencode(each.value.properties.policyRule)
  parameters          = jsonencode(each.value.properties.parameters)
  metadata            = jsonencode(each.value.properties.metadata)
  management_group_id = var.management_group_id
    provider = azurerm.policy
}

resource "azurerm_management_group_policy_assignment" "main" {
  for_each             = azurerm_policy_definition.main
  name                 = substr(split(".", each.value.name)[0], 0, 24)
  policy_definition_id = each.value.id
  management_group_id  = var.management_group_id
  depends_on = [
    azurerm_policy_definition.main
  ]
  provider = azurerm.policy
}
