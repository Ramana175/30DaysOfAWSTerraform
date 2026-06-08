# =============================================================================
# Assignment 10: Cost Calculation Dashboard
# =============================================================================
# Purpose:
# Calculate cloud costs and identify expensive services.
#
# Functions Used:
# - sum()
# - max()
# - abs()
# =============================================================================

locals {

  # Extract cost values

  costs = values(var.service_costs)

  # Total Monthly Cost

  total_cost = sum(local.costs)

  # Most Expensive Service Cost

  highest_cost = max(local.costs...)

  # Budget Difference

  budget_difference = abs(
    var.monthly_budget - local.total_cost
  )

}