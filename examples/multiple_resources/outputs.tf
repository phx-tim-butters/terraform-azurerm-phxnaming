output "resources" {
  value = { for rk, rv in local.resource_naming : rk => {
    resource_name       = module.naming[rk].name
    resource_group_name = module.naming[rk].resource_group_name
    global_name         = module.naming[rk].global_name
    region_details      = module.naming[rk].region_details
    }
  }
}
