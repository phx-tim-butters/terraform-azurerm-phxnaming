module "naming" {
  source = "../.."

  org_abbreviation      = "org1"
  structure             = "TYPE-ORG-REGION-ARCH-NAME"
  archetype             = "prod"
  workload_abbreviation = "prod"
  location              = "uksouth"

  resource_type = "virtual_machine"
  resource_name = "DC01"

  resource_group_name = "identity"

  region_code_overrides = {
    uksouth = "timbucktoo"
  }

  resource_type_overrides = {
    virtual_machine = "sausage"
    resource_group  = "biscuits"
  }
}
