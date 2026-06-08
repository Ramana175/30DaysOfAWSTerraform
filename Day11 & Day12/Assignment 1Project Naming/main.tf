# =============================================================================
# Assignment 1: Project Naming
# =============================================================================
# Purpose:
# Standardize project names using Terraform String Functions.
#
# Problem:
# Different engineers may use different naming conventions.
#
# Example Input:
# Project ALPHA Resource
#
# Example Output:
# project-alpha-resource
#
# Functions Used:
# - lower()
# - replace()
#
# Real-World Use Cases:
# - S3 Bucket Naming
# - IAM Role Naming
# - Resource Naming Standards
# - Kubernetes Resource Names
# =============================================================================

locals {

  standardized_project_name = lower(
    replace(
      var.project_name,
      " ",
      "-"
    )
  )
}