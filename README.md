# Azure Resource Naming Convention - Terraform Module

A simple, flexible Terraform module for generating consistent Azure resource names based on a user-defined naming structure. This module ensures uniform naming conventions across single or multiple resources, making it ideal for organizations that need standardized resource naming across their Azure infrastructure.

## Features

- **Flexible Naming Structure**: Define your own naming pattern using placeholders (ORG, REGION, ENV, PURPOSE, ARCH, TYPE, NAME)
- **Single or Multiple Resources**: Works seamlessly with individual resources or `for_each` loops for bulk naming
- **238+ Azure Resource Types**: Pre-configured abbreviations aligned with [Microsoft Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- **All Azure Regions**: Built-in abbreviations for every Azure region
- **Global Resource Support**: Automatically handles globally unique resources (e.g., Storage Accounts) by removing hyphens and truncating to 24 characters
- **Case Control**: Options for uppercase, lowercase, or preserve original case
- **Optional Components**: All structure placeholders are optional - use only what you need

## Quick Start

### Single Resource Example

```hcl
module "vm_name" {
  source = "path/to/module"

  # Organization settings
  org_abbreviation = "contoso"
  structure        = "TYPE-ORG-REGION-ARCH-NAME"
  
  # Location and classification
  location  = "uksouth"
  archetype = "web"
  
  # Resource specifics
  resource_type = "virtual_machine"
  resource_name = "app01"
  
  case_option = "lower"
}

# Output: vm-contoso-uks-web-app01
```

### Multiple Resources Example

```hcl
locals {
  resources = {
    vnet = {
      resource_type = "virtual_network"
      resource_name = "hub"
    }
    storage = {
      resource_type = "storage_account"
      resource_name = "logs"
      random        = true  # Add random suffix for uniqueness
    }
    keyvault = {
      resource_type = "key_vault"
      resource_name = "secrets"
    }
  }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

module "naming" {
  source   = "path/to/module"
  for_each = local.resources

  org_abbreviation = "contoso"
  structure        = "TYPE-ORG-REGION-ENV-NAME"
  location         = "eastus"
  env_abbreviation = "prod"
  
  resource_type = each.value.resource_type
  resource_name = each.value.resource_name
  
  deployment_random_string = try(each.value.random, false) ? random_string.suffix.result : null
}

# Outputs:
# vnet-contoso-eus-prod-hub
# st-contoso-eus-prod-logs7a3f (globally unique)
# kv-contoso-eus-prod-secrets
```

## Naming Structure

The `structure` variable defines your naming pattern using these placeholders:

| Placeholder | Description | Example Values |
|-------------|-------------|----------------|
| **TYPE** | Resource type abbreviation (auto-mapped) | `vm`, `vnet`, `st`, `kv` |
| **ORG** | Organization abbreviation | `contoso`, `acme`, `fabrikam` |
| **REGION** | Azure region abbreviation (auto-mapped) | `uks`, `eus`, `we` |
| **ENV** | Environment identifier | `prod`, `dev`, `test`, `uat` |
| **PURPOSE** | Resource purpose or function | `network`, `backup`, `logs` |
| **ARCH** | Workload archetype | `web`, `data`, `sec`, `net` |
| **NAME** | Specific resource identifier | `app01`, `dc01`, `core` |

### Example Structures

```hcl
# Simple structure
structure = "TYPE-ORG-NAME"
# Result: vm-contoso-app01

# Environment-focused
structure = "TYPE-ENV-PURPOSE-NAME"
# Result: vnet-prod-dmz-frontend

# Full structure with all placeholders
structure = "TYPE-ORG-REGION-ENV-ARCH-PURPOSE-NAME"
# Result: kv-contoso-uks-prod-sec-backup-vault01

# Custom separators
structure = "ORG_ENV_TYPE_NAME"
# Result: contoso_prod_vm_app01
```

## Supported Resource Types

The module includes 238+ Azure resource types across all categories:

### Common Resources
- **Compute**: `virtual_machine`, `virtual_machine_scale_set`, `availability_set`, `disk_encryption_set`
- **Networking**: `virtual_network`, `virtual_network_subnet`, `network_security_group`, `public_ip`, `load_balancer_internal`, `application_gateway`
- **Storage**: `storage_account`, `file_share`, `backup_vault`
- **Security**: `key_vault`, `bastion`, `vpn_gateway`, `managed_identity`
- **Databases**: `sql_server`, `sql_database`, `cosmos_db`, `redis_cache`, `mysql_database`, `postgresql_database`
- **Containers**: `aks_cluster`, `container_registry`, `container_app`
- **Integration**: `logic_app`, `api_management`, `service_bus_namespace`
- **AI/ML**: `machine_learning_workspace`, `openai_service`, `ai_search`
- **Analytics**: `data_factory`, `synapse_workspace`, `databricks_workspace`, `event_hub`

[View complete list in locals.types.tf](locals.types.tf)

## Azure Region Abbreviations

The module automatically converts Azure region names to standardized abbreviations:

| Region | Abbreviation | Region | Abbreviation |
|--------|--------------|--------|--------------|
| uksouth | uks | ukwest | ukw |
| eastus | eus | eastus2 | eus2 |
| westeurope | we | northeurope | ne |
| southeastasia | sea | eastasia | ea |
| australiaeast | ae | centralus | cus |

[View complete list in locals.region.tf](locals.region.tf)

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archetype"></a> [archetype](#input\_archetype) | Archetype or category of the resource, used in the ARCH placeholder (e.g., 'web', 'db', 'api'). Optional, leave empty if not using ARCH in your structure. | `string` | `""` | no |
| <a name="input_case_option"></a> [case\_option](#input\_case\_option) | Controls the case transformation of generated names. Options: 'lower' (lowercase), 'upper' (uppercase), 'none' (no transformation). Default: 'lower'. | `string` | `"lower"` | no |
| <a name="input_deploy_abbreviation"></a> [deploy\_abbreviation](#input\_deploy\_abbreviation) | Deployment-specific suffix appended to the end of the resource name (e.g., '001', 'blue', 'green'). Useful for blue-green deployments or numbered instances. Optional. | `string` | `""` | no |
| <a name="input_deployment_random_string"></a> [deployment\_random\_string](#input\_deployment\_random\_string) | Random string to append for uniqueness in deployments (e.g., '7f3a', 'x9k2'). Useful for ensuring globally unique names or identifying specific deployment instances. Optional. | `string` | `null` | no |
| <a name="input_env_abbreviation"></a> [env\_abbreviation](#input\_env\_abbreviation) | Environment identifier used in the ENV placeholder (e.g., 'prod', 'dev', 'test', 'uat', 'nonprod'). Optional, leave empty if not using ENV in your structure. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the resource will be deployed (e.g., 'uksouth', 'eastus', 'westeurope'). This will be automatically converted to a region abbreviation for the REGION placeholder. | `string` | n/a | yes |
| <a name="input_org_abbreviation"></a> [org\_abbreviation](#input\_org\_abbreviation) | Organization or company abbreviation used in the ORG placeholder (e.g., 'contoso', 'acme', 'fabrikam'). Helps identify resources belonging to your organization. | `string` | n/a | yes |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Functional purpose or workload of the resource, used in the PURPOSE placeholder (e.g., 'network', 'backup', 'monitoring'). Optional, leave empty if not using PURPOSE in your structure. | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Base name for the resource group of this resource without any naming convention applied. This value will be used in the NAME placeholder of the structure pattern (e.g., 'dc01', 'web01', 'core'). | `string` | `""` | no |
| <a name="input_resource_group_name_overwrite"></a> [resource\_group\_name\_overwrite](#input\_resource\_group\_name\_overwrite) | Bypass naming convention and use resource\_group\_name exactly as provided without applying any structure pattern. Useful for legacy systems or externally mandated names. Default: false. | `bool` | `false` | no |
| <a name="input_resource_group_purpose"></a> [resource\_group\_purpose](#input\_resource\_group\_purpose) | Functional purpose of the resource group, used in the PURPOSE placeholder when resource\_group\_structure is defined (e.g., 'network', 'shared', 'core'). Optional. | `string` | `""` | no |
| <a name="input_resource_group_structure"></a> [resource\_group\_structure](#input\_resource\_group\_structure) | Optional separate naming structure for resource groups. Uses same placeholders as 'structure'. If null, the main 'structure' pattern is used. Useful when resource groups need different naming than their resources. | `string` | `null` | no |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | Base name for the resource without any naming convention applied. This value will be used in the NAME placeholder of the structure pattern (e.g., 'dc01', 'web01', 'core'). | `string` | `""` | no |
| <a name="input_resource_name_overwrite"></a> [resource\_name\_overwrite](#input\_resource\_name\_overwrite) | Bypass naming convention and use resource\_name exactly as provided without applying any structure pattern. Useful for legacy systems or externally mandated names. Default: false. | `bool` | `false` | no |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | Azure resource type to be named. Must match a key from the naming\_convention map in locals.types.tf (e.g., 'virtual\_machine', 'storage\_account', 'key\_vault'). | `string` | `""` | no |
| <a name="input_structure"></a> [structure](#input\_structure) | Naming structure pattern using placeholders: ORG, REGION, ENV, PURPOSE, ARCH, TYPE, NAME. Example: 'TYPE-ORG-REGION-ENV-ARCH-NAME' produces 'vm-contoso-uks-prod-web-app01'. | `string` | n/a | yes |
| <a name="input_workload_abbreviation"></a> [workload\_abbreviation](#input\_workload\_abbreviation) | Workload  used in the WORK placeholder (e.g., 'web', 'data', 'sec' for security, 'net' for networking, 'id' for identity). Defines the application or infrastructure pattern. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_global_name"></a> [global\_name](#output\_global\_name) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->

## Maintainer

Phoenix Software
