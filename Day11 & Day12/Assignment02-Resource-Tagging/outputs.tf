# =============================================================================
# Outputs
# =============================================================================

output "vpc_id" {

  description = "VPC ID"

  value = aws_vpc.demo_vpc.id
}

output "merged_tags" {

  description = "Combined Tags"

  value = local.final_tags
}