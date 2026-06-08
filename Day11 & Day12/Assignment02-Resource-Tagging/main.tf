# =============================================================================
# Assignment 2: Resource Tagging
# =============================================================================
# Purpose:
# Demonstrate how to combine multiple tag maps using merge().
#
# Problem:
# Organizations require common tags on all resources.
#
# Functions Used:
# - merge()
#
# Real-World Use Cases:
# - Cost Allocation
# - Resource Ownership
# - Governance
# - Compliance Tracking
# =============================================================================

locals {

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Team        = "DevOps"
  }

  project_tags = {
    Project = var.project_name
    Owner   = var.owner
  }

  final_tags = merge(
    local.common_tags,
    local.project_tags
  )
}

resource "aws_vpc" "demo_vpc" {

  cidr_block = "10.0.0.0/16"

  tags = local.final_tags
}