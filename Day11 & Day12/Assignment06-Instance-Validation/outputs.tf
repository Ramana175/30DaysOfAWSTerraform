# =============================================================================
# Outputs
# =============================================================================

output "instance_type" {

  value = var.instance_type
}

output "instance_type_length" {

  value = local.instance_type_length
}

output "validation_result" {

  value = local.valid_instance_type
}