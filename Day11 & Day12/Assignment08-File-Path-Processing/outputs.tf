# =============================================================================
# Outputs
# =============================================================================

output "config_file_exists" {

  description = "Does the file exist?"

  value = local.config_file_exists
}

output "config_directory" {

  description = "Directory extracted from path"

  value = local.config_directory
}