# =============================================================================
# Outputs
# =============================================================================
# Purpose:
# Display original and transformed project names.
# =============================================================================

output "original_project_name" {

  description = "Original Project Name"

  value = var.project_name
}

output "standardized_project_name" {

  description = "Standardized Project Name"

  value = local.standardized_project_name
}