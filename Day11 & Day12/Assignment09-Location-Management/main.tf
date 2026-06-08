# =============================================================================
# Assignment 09: Location Management
# =============================================================================
# Purpose:
# Combine multiple AWS region lists and remove duplicates.
#
# Problem:
# Organizations often receive region lists from multiple teams.
#
# Example:
#
# Team A:
# us-east-1
# us-west-2
#
# Team B:
# us-west-2
# eu-west-1
# ap-south-1
#
# Functions Used:
# - concat()
# - toset()
#
# Real-World Use Cases:
# - Multi-Region Deployments
# - Disaster Recovery Planning
# - Global Infrastructure
# - Cloud Migration Projects
# =============================================================================

locals {

  # Combine both region lists

  all_regions = concat(
    var.primary_regions,
    var.secondary_regions
  )

  # Remove duplicates

  unique_regions = toset(
    local.all_regions
  )
}