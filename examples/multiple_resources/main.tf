resource "random_string" "resource_name_randoms" {

  length  = 4
  upper   = false
  lower   = true
  numeric = true
  special = false
}

module "naming" {
  source   = "../../"
  for_each = local.resource_naming

  resource_type       = each.value.resource_type
  resource_name       = each.value.resource_name
  resource_group_name = try(each.value.resource_group_name, local.resource_group_name)

  org_abbreviation = local.org_abbreviation
  structure        = local.structure
  location         = local.location
  archetype        = local.archetype

  deployment_random_string = try(each.value.random, false) ? random_string.resource_name_randoms.result : null
}

