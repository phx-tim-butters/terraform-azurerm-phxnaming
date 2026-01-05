output "name" {
  value = var.case_option == "upper" ? upper(local.returned_resource_name) : var.case_option == "lower" ? lower(local.returned_resource_name) : local.returned_resource_name
}

output "global_name" {
  value = var.case_option == "upper" ? upper(local.returned_global_resource_name) : var.case_option == "lower" ? lower(local.returned_global_resource_name) : local.returned_global_resource_name
}

output "resource_group_name" {
  value = var.case_option == "upper" ? upper(local.returned_resource_group_name) : var.case_option == "lower" ? lower(local.returned_resource_group_name) : local.returned_resource_group_name
}
