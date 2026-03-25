locals {
  completed_location            = local.region_abbreviation[var.location]
  completed_deploy_abbreviation = var.deploy_abbreviation == "" ? "" : "-${var.deploy_abbreviation}"
}

# We want to return the midfix based on a naming convention
locals {
  structure_replaced_resource_name1 = replace(var.structure, "ORG", var.org_abbreviation)
  structure_replaced_resource_name2 = replace(local.structure_replaced_resource_name1, "REGION", local.completed_location)
  structure_replaced_resource_name3 = replace(local.structure_replaced_resource_name2, "ENV", var.env_abbreviation)
  structure_replaced_resource_name4 = replace(local.structure_replaced_resource_name3, "PURPOSE", var.purpose)
  structure_replaced_resource_name5 = replace(local.structure_replaced_resource_name4, "ARCH", var.archetype)
  structure_replaced_resource_name6 = replace(local.structure_replaced_resource_name5, "TYPE", local.types[var.resource_type])
  structure_replaced_resource_name7 = replace(local.structure_replaced_resource_name6, "NAME", var.resource_name)

  random_resource_name = (var.deployment_random_string == null ?
    "${local.structure_replaced_resource_name7}" :
    "${local.structure_replaced_resource_name7}${var.deployment_random_string}"
  )

  deploy_resource_name = var.resource_name_overwrite ? var.resource_name : (
    "${local.random_resource_name}${local.completed_deploy_abbreviation}"
  )

  replaced_global_resource_name  = replace(local.completed_resource_name, "-", "")
  truncated_global_resource_name = length(local.replaced_global_resource_name) > 24 ? substr(local.replaced_global_resource_name, 1, 24) : local.replaced_global_resource_name

  # Marker to the last completed resource (and global) name, takes into consideration all previous requires replacement and steps
  completed_resource_name        = local.deploy_resource_name
  completed_global_resource_name = local.truncated_global_resource_name

  returned_resource_name        = local.completed_resource_name
  returned_global_resource_name = local.completed_global_resource_name
}

locals {

  resource_group_name = var.resource_group_name == "" ? var.resource_name : var.resource_group_name

  # If the incoming Resource Group Structure is null, we default to the main structure
  resource_group_structure = var.resource_group_structure != null ? var.resource_group_structure : var.structure

  structure_replaced_resource_group_name1 = replace(local.resource_group_structure, "ORG", var.org_abbreviation)
  structure_replaced_resource_group_name2 = replace(local.structure_replaced_resource_group_name1, "REGION", local.completed_location)
  structure_replaced_resource_group_name3 = replace(local.structure_replaced_resource_group_name2, "ENV", var.env_abbreviation)
  structure_replaced_resource_group_name4 = replace(local.structure_replaced_resource_group_name3, "PURPOSE", var.resource_group_purpose)
  structure_replaced_resource_group_name5 = replace(local.structure_replaced_resource_group_name4, "ARCH", var.archetype)
  structure_replaced_resource_group_name6 = replace(local.structure_replaced_resource_group_name5, "TYPE", local.types["resource_group"])
  structure_replaced_resource_group_name7 = replace(local.structure_replaced_resource_group_name6, "NAME", local.resource_group_name)

  completed_resource_group_name = var.resource_group_name_overwrite ? var.resource_group_name : local.structure_replaced_resource_group_name7

  returned_resource_group_name = local.completed_resource_group_name
}
