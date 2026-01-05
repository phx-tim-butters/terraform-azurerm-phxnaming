module "naming" {
  source = "../../"

  org_abbreviation = local.org_abbreviation
  structure        = local.structure

  location  = local.location
  archetype = local.archetype

  resource_type       = "virtual_machine"
  resource_name       = "DC01"
  resource_group_name = "identity"

  case_option = "lower"
}
