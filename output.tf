output "policies" {
  value = [for policies in azurerm_policy_definition.main : policies]
}

output "assignments" {
  value = [for assignments in azurerm_management_group_policy_assignment.main : assignments]
}