module "naming" {
  source = "../.."

  org_abbreviation = local.org_abbreviation
  structure        = local.structure
  archetype        = local.archetype

  location = local.default_location

  resource_type = "virtual_machine"
  resource_name = "DC01"

  resource_group_name = "identity"
}
