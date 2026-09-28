module "regions" {
  count   = var.enable_region_lookup ? 1 : 0
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.12.0"

  enable_telemetry = false

  region_filter = [
    var.location
  ]
}
