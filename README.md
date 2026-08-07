# Phoenix Software - Azure Terraform Naming Module

This module generates consistent Azure resource names from a configurable naming structure. It maps Azure regions to abbreviations, maps Azure resource types to short names, and returns standardized outputs for resource names, resource group names, and globally constrained names.

## Intent

Provide a reusable naming engine for Terraform deployments so teams can apply one naming convention across Azure resources without rebuilding string logic in every stack.

The module is designed to:

- Build names from placeholder-driven patterns such as ORG, REGION, ENV, PURPOSE, ARCH, WORK, TYPE, and NAME.
- Support both standard resources and resource groups, including a dedicated resource-group structure when needed.
- Handle globally constrained names by normalizing separators and applying length constraints.
- Allow practical overrides and deployment context values such as random suffixes, deploy suffixes, and case transformation.

## Principles

- Convention first: generate names from a declared structure rather than ad hoc concatenation.
- Deterministic output: identical inputs produce identical names.
- Azure-aware mapping: use curated local maps for resource types and regions.
- Flexible adoption: optional placeholders and explicit overwrite switches support legacy or exception cases.
- Consumer-friendly outputs: return standard, global-safe, and resource-group name variants.

## Terraform Documentation (TFDocs)

<!-- BEGIN_TF_DOCS -->
<!-- TFDocs content is generated automatically. -->
<!-- END_TF_DOCS -->

## Maintainer

Phoenix Software
