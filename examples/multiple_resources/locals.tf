locals {
  org_abbreviation = "org1"
  structure        = "TYPE-ORG-REGION-ARCH-NAME"
  location         = "uksouth"
  archetype        = "prod"

  resource_group_name = "test"

  resource_naming = {
    virtual_network = {
      resource_type = "virtual_network"
      resource_name = "prod-spoke"
    }
    sa_intermediate = {
      resource_type = "storage_account"
      resource_name = "rawdata"
    }
    vm_name = {
      resource_type = "virtual_machine"
      resource_name = "downloader"
    }
    vm_nic = {
      resource_type = "network_interface"
      resource_name = "downloader"
    }
    vm_disk = {
      resource_type = "managed_disk_os"
      resource_name = "downloader"
    }
    route_table = {
      resource_type = "route_table"
      resource_name = "prod-spoke"
    }
    public_ip = {
      resource_type = "public_ip"
      resource_name = "downloader"
    }
    keyvault = {
      resource_type = "key_vault"
      resource_name = "rawdata"
      random        = true
    }
  }

}
