# =============================================================================
# Outputs
# =============================================================================

output "primary_regions" {

  value = var.primary_regions
}

output "secondary_regions" {

  value = var.secondary_regions
}

output "combined_regions" {

  value = local.all_regions
}

output "unique_regions" {

  value = local.unique_regions
}