resource "random_string" "resource_name_randoms" {

  length  = 4
  upper   = false
  lower   = true
  numeric = true
  special = false
}

module "naming" {
  source   = "../.."
  for_each = local.resource_naming

  archetype             = try(coalesce(each.value.archetype, null), coalesce(local.archetype, null), local.workload_abbreviation)
  workload_abbreviation = try(coalesce(each.value.workload_abbreviation, null), coalesce(local.workload_abbreviation, null), local.archetype)
  org_abbreviation      = local.org_abbreviation
  env_abbreviation      = try(coalesce(each.value.environment, null), "")
  structure             = coalesce(try(each.value.structure, null), local.structure)
  deploy_abbreviation   = try(local.deploy_abbreviation, "")
  location              = coalesce(try(each.value.location, null), local.default_location)

  resource_type           = each.value.resource_type
  resource_name           = each.value.resource_name
  resource_name_overwrite = try(each.value.resource_name_overwrite, false)

  resource_group_name           = local.resource_group_name
  resource_group_name_overwrite = try(each.value.resource_group_name_overwrite, false)

  case_option = coalesce(try(each.value.case_option, null), "lower")

  deployment_random_string = try(each.value.random, false) ? random_string.resource_name_randoms.result : null
}
