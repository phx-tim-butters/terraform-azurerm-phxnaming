variable "resource_type" {
  type        = string
  description = "Azure resource type to be named. Must match a key from the naming_convention map in locals.types.tf (e.g., 'virtual_machine', 'storage_account', 'key_vault')."
  default     = ""
}

variable "resource_name" {
  type        = string
  description = "Base name for the resource without any naming convention applied. This value will be used in the NAME placeholder of the structure pattern (e.g., 'dc01', 'web01', 'core')."
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "Base name for the resource group of this resource without any naming convention applied. This value will be used in the NAME placeholder of the structure pattern (e.g., 'dc01', 'web01', 'core')."
  default     = ""
}

variable "structure" {
  type        = string
  description = "Naming structure pattern using placeholders: ORG, REGION, ENV, PURPOSE, ARCH, TYPE, NAME. Example: 'TYPE-ORG-REGION-ENV-ARCH-NAME' produces 'vm-contoso-uks-prod-web-app01'."
}

variable "resource_group_structure" {
  type        = string
  description = "Optional separate naming structure for resource groups. Uses same placeholders as 'structure'. If null, the main 'structure' pattern is used. Useful when resource groups need different naming than their resources."
  default     = null
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be deployed (e.g., 'uksouth', 'eastus', 'westeurope'). This will be automatically converted to a region abbreviation for the REGION placeholder."
}

variable "purpose" {
  type        = string
  description = "Functional purpose or workload of the resource, used in the PURPOSE placeholder (e.g., 'network', 'backup', 'monitoring'). Optional, leave empty if not using PURPOSE in your structure."
  default     = ""
}

variable "resource_group_purpose" {
  type        = string
  description = "Functional purpose of the resource group, used in the PURPOSE placeholder when resource_group_structure is defined (e.g., 'network', 'shared', 'core'). Optional."
  default     = ""
}

variable "archetype" {
  type        = string
  description = "Workload archetype or classification used in the ARCH placeholder (e.g., 'web', 'data', 'sec' for security, 'net' for networking, 'id' for identity). Defines the application or infrastructure pattern."
}

variable "env_abbreviation" {
  type        = string
  description = "Environment identifier used in the ENV placeholder (e.g., 'prod', 'dev', 'test', 'uat', 'nonprod'). Optional, leave empty if not using ENV in your structure."
  default     = ""
}

variable "deploy_abbreviation" {
  type        = string
  default     = ""
  description = "Deployment-specific suffix appended to the end of the resource name (e.g., '001', 'blue', 'green'). Useful for blue-green deployments or numbered instances. Optional."
}

variable "org_abbreviation" {
  type        = string
  description = "Organization or company abbreviation used in the ORG placeholder (e.g., 'contoso', 'acme', 'fabrikam'). Helps identify resources belonging to your organization."
}

variable "deployment_random_string" {
  type        = string
  description = "Random string to append for uniqueness in deployments (e.g., '7f3a', 'x9k2'). Useful for ensuring globally unique names or identifying specific deployment instances. Optional."
  default     = null
}

variable "resource_name_overwrite" {
  type        = bool
  description = "Bypass naming convention and use resource_name exactly as provided without applying any structure pattern. Useful for legacy systems or externally mandated names. Default: false."
  default     = false
}

variable "resource_group_name_overwrite" {
  type        = bool
  description = "Bypass naming convention and use resource_group_name exactly as provided without applying any structure pattern. Useful for legacy systems or externally mandated names. Default: false."
  default     = false
}

variable "case_option" {
  type        = string
  description = "Controls the case transformation of generated names. Options: 'lower' (lowercase), 'upper' (uppercase), 'none' (no transformation). Default: 'lower'."
  default     = "lower"
  validation {
    condition     = contains(["none", "upper", "lower"], var.case_option)
    error_message = "Case option must be one of: 'none', 'upper', 'lower'."
  }
}
