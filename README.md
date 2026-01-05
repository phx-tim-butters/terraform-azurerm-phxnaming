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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| structure | Naming structure pattern using placeholders | `string` | n/a | yes |
| org_abbreviation | Organization or company abbreviation | `string` | n/a | yes |
| archetype | Workload archetype or classification | `string` | n/a | yes |
| location | Azure region where the resource will be deployed | `string` | n/a | yes |
| resource_type | Azure resource type (must match naming_convention key) | `string` | `""` | no |
| resource_name | Base name for the resource without convention | `string` | `""` | no |
| resource_group_structure | Optional separate naming structure for resource groups | `string` | `null` | no |
| env_abbreviation | Environment identifier (e.g., prod, dev, test) | `string` | `""` | no |
| purpose | Functional purpose or workload of the resource | `string` | `""` | no |
| resource_group_purpose | Functional purpose of the resource group | `string` | `""` | no |
| deploy_abbreviation | Deployment-specific suffix | `string` | `""` | no |
| deployment_random_string | Random string for uniqueness | `string` | `null` | no |
| resource_name_overwrite | Bypass convention and use resource_name exactly | `bool` | `false` | no |
| case_option | Case transformation: 'lower', 'upper', or 'none' | `string` | `"lower"` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | Generated resource name following the naming convention |
| global_name | Name for globally unique resources (lowercase, no hyphens, max 24 chars) |
| resource_group_name | Generated resource group name |

## Usage Examples

### Example 1: Infrastructure with Environment Separation

```hcl
module "prod_vnet" {
  source = "path/to/module"

  org_abbreviation = "contoso"
  structure        = "TYPE-ORG-REGION-ENV-PURPOSE-NAME"
  
  location         = "uksouth"
  env_abbreviation = "prod"
  purpose          = "network"
  archetype        = "net"
  
  resource_type = "virtual_network"
  resource_name = "hub"
}
# Output: vnet-contoso-uks-prod-network-hub
```

### Example 2: Storage Account with Random Suffix

```hcl
resource "random_string" "storage_suffix" {
  length  = 4
  special = false
  upper   = false
}

module "storage_name" {
  source = "path/to/module"

  org_abbreviation         = "contoso"
  structure                = "TYPE-ORG-REGION-ARCH-NAME"
  location                 = "eastus"
  archetype                = "data"
  resource_type            = "storage_account"
  resource_name            = "rawdata"
  deployment_random_string = random_string.storage_suffix.result
}
# Global name output: stcontosoeusrawdata7a3f (suitable for storage account)
```

### Example 3: Multiple Resources with Consistent Naming

```hcl
locals {
  base_config = {
    org_abbreviation = "fabrikam"
    structure        = "TYPE-ORG-REGION-ARCH-NAME"
    location         = "westeurope"
    archetype        = "web"
  }

  web_resources = {
    vm     = { type = "virtual_machine", name = "webapp01" }
    disk   = { type = "managed_disk_os", name = "webapp01" }
    nic    = { type = "network_interface", name = "webapp01" }
    pip    = { type = "public_ip", name = "webapp01" }
    lb     = { type = "load_balancer_internal", name = "web" }
  }
}

module "web_naming" {
  source   = "path/to/module"
  for_each = local.web_resources

  org_abbreviation = local.base_config.org_abbreviation
  structure        = local.base_config.structure
  location         = local.base_config.location
  archetype        = local.base_config.archetype
  
  resource_type = each.value.type
  resource_name = each.value.name
}

# Outputs:
# vm-fabrikam-we-web-webapp01
# osdisk-fabrikam-we-web-webapp01
# nic-fabrikam-we-web-webapp01
# pip-fabrikam-we-web-webapp01
# lbi-fabrikam-we-web-web
```

### Example 4: Separate Resource Group Naming

```hcl
module "kv_naming" {
  source = "path/to/module"

  org_abbreviation     = "contoso"
  structure            = "TYPE-ORG-REGION-ENV-ARCH-NAME"
  resource_group_structure = "TYPE-ORG-REGION-PURPOSE"
  
  location  = "uksouth"
  env_abbreviation = "prod"
  archetype = "sec"
  purpose   = "secrets"
  
  resource_type = "key_vault"
  resource_name = "vault01"
}

# Resource name: kv-contoso-uks-prod-sec-vault01
# Resource group name: rg-contoso-uks-secrets
```

### Example 5: Uppercase Naming (Legacy Systems)

```hcl
module "legacy_vm" {
  source = "path/to/module"

  org_abbreviation = "contoso"
  structure        = "TYPE-REGION-NAME"
  location         = "northeurope"
  archetype        = "legacy"
  resource_type    = "virtual_machine"
  resource_name    = "mainframe"
  
  case_option = "upper"
}
# Output: VM-NE-MAINFRAME
```

## Best Practices

1. **Define Standard Structures**: Establish 2-3 standard structures for your organization (e.g., one for production, one for development)
2. **Document Your Placeholders**: Maintain a guide of what each placeholder value means in your organization
3. **Use Archetypes Consistently**: Define standard archetypes (web, data, sec, net, etc.) and use them uniformly
4. **Leverage For_Each**: When naming multiple related resources, use `for_each` to maintain consistency
5. **Test Globally Unique Names**: For resources like Storage Accounts, always check the `global_name` output
6. **Consider Length Limits**: Some Azure resources have strict name length limits (e.g., Storage Accounts max 24 chars)
7. **Use Random Suffixes Wisely**: Apply `deployment_random_string` to resources that need guaranteed uniqueness

## Global vs Regular Names

Some Azure resources require globally unique names. The module provides both outputs:

- **`name`**: Standard formatted name with hyphens (e.g., `st-contoso-uks-prod-logs`)
- **`global_name`**: Lowercase, no hyphens, max 24 chars (e.g., `stcontosouksprodlogs`)

**Resources requiring global names:**
- Storage Accounts
- Key Vaults (global within Azure AD tenant)
- Azure Cosmos DB accounts
- Azure Cache for Redis
- App Configuration stores

Always use `global_name` output for these resources.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

No external providers required - this module uses only native Terraform functions.

## Examples

Complete working examples are available in the [examples](examples/) directory:
- [single_resource](examples/single_resource/) - Basic single resource naming
- [multiple_resources](examples/multiple_resources/) - Using for_each to name multiple resources

## Contributing

Contributions are welcome! If you'd like to add resource types or region abbreviations:
1. Update `locals.types.tf` for new resource types
2. Update `locals.region.tf` for new regions
3. Ensure additions follow Microsoft Cloud Adoption Framework guidelines

## License

See [LICENSE](LICENSE) file for details.

## Authors

Module maintained by your organization.

## References

- [Azure Resource Abbreviations - Microsoft Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Azure Resource Naming Conventions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Terraform Module Registry Standards](https://www.terraform.io/registry/modules/publish)
