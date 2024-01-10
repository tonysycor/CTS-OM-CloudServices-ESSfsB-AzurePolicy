
data "azurerm_management_group" "management" {
  for_each    =  local.merged_objects
  display_name    = each.value.management_scope == "Company" ? var.management_scope : each.value.management_scope
 

}
resource "azurerm_policy_definition" "definition" {

  for_each    = local.merged_objects

  name        = each.key
  display_name = each.key
  description = jsondecode(each.value.body).description
  mode        = jsondecode(each.value.body).mode
  policy_type = jsondecode(each.value.body).policyType
  management_group_id = data.azurerm_management_group.management[each.key].id
  metadata = jsonencode(jsondecode(each.value.body).metadata)

  parameters = jsonencode(jsondecode(each.value.body).parameters)

  policy_rule = jsonencode(jsondecode(each.value.body).policyRule)

}


resource "azurerm_management_group_policy_assignment" "assignment" {
  for_each    = local.merged_objects
  

  name                 = each.key
  policy_definition_id = azurerm_policy_definition.definition[each.key].id
  management_group_id  = data.azurerm_management_group.management[each.key].id
  location = var.assignment_location


 
  identity {
    type = "SystemAssigned"
  }
  
  parameters = each.value.parameters

}

resource "azurerm_management_group_policy_remediation" "remediation" {
  for_each    = local.merged_objects
  name                 = format("remediation-%s", lower(each.key))

  management_group_id  = data.azurerm_management_group.management[each.key].id
  policy_assignment_id = azurerm_management_group_policy_assignment.assignment[each.key].id
}
output "management_group_display_names" {
  value = [for mg in data.azurerm_management_group.management : mg.display_name]
  sensitive =true
}
