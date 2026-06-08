# =============================================================================
# Assignment 08: File Path Processing
# =============================================================================
# Purpose:
# Validate file existence and extract directory paths.
#
# Problem:
# Missing configuration files can cause deployment failures.
#
# Functions Used:
# - fileexists()
# - dirname()
#
# Example:
#
# Input:
# configs/dev/config.json
#
# Output:
# configs/dev
#
# Real-World Use Cases:
# - Configuration Management
# - JSON/YAML Files
# - Terraform Modules
# - Infrastructure Automation
# =============================================================================

locals {

  # Check if file exists

  config_file_exists = fileexists(
    var.config_file_path
  )

  # Extract directory path

  config_directory = dirname(
    "configs/dev/config.json"
  )
}