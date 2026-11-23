variables {
  org_abbreviation      = "tftest"
  structure             = "TYPE-ORG-REGION-ENV-WORK-NAME"
  workload_abbreviation = "tftest"
  env_abbreviation      = "prod"

  location = "uksouth"

  resource_type = "virtual_machine"
  resource_name = "DC01"

  resource_group_name = "identity"
}

run "default" {

  command = apply

  assert {
    condition     = output.name == "vm-tftest-uks-p-tftest-dc01"
    error_message = "Resource name does not match expected format"
  }

  assert {
    condition     = output.region_details.geo_code == "uks"
    error_message = "Region short code does not come back as expected"
  }

  assert {
    condition     = length(output.region_details.zones) == 3
    error_message = "Region details returns a zone map with 3 zones and can be used downstream"
  }
}