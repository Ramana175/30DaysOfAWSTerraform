# =============================================================================
# Outputs
# =============================================================================

output "environment" {

  description = "Selected Environment"

  value = var.environment
}

output "instance_type" {

  description = "Selected Instance Type"

  value = local.selected_instance_type
}

output "instance_id" {

  description = "EC2 Instance ID"

  value = aws_instance.environment_demo.id
}