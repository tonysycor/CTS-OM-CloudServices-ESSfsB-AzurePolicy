locals {
 policy_csv = csvdecode(file(var.policy_file))
 policy   = { for r in local.policy_csv : r.name => r }
 management_scopes_from_csv = [for row in local.policy   : row.management_scope]
}


data "http" "policy_data2" {
  for_each = local.policy
  url = "${each.value.url}${var.sas}"
  request_headers = {
    Accept = "application/json"
  }
  
}
locals {
  data1 = jsonencode(data.http.policy_data2)
  decoded_json = jsondecode(local.data1)
  
  data2 = tolist(local.management_scopes_from_csv)
  data3 = { for idx, value in local.data2 : idx => value }
  merged_data = [for item in local.decoded_json : merge(item, {"management_group" = local.management_scopes_from_csv[length(local.management_scopes_from_csv) - 1] })]
 
  merge2 = [
    for i, row in local.policy :
    merge(row, local.decoded_json[row.name])
  ]
   merged_objects = {
   for item in local.merge2 : item.name => item
  }
}

 