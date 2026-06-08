# =============================================================================
# Assignment 06: Instance Validation
# =============================================================================
# Purpose:
# Validate instance types before resource creation.
#
# Problem:
# Invalid instance types can cause deployment failures.
#
# Functions Used:
# - length()
# - can()
# - regex()
#
# Example:
#
# Valid:
# t3.micro
# t3.small
# t3.medium
#
# Invalid:
# abc123
# test-instance
# xyz.large
#
# Real-World Use Cases:
# - Input Validation
# - Policy Enforcement
# - Compliance Checks
# - Infrastructure Standards
# =============================================================================

locals {

  # Check instance type pattern

  valid_instance_type = can(
    regex(
      "^t3\\.",
      var.instance_type
    )
  )

  # Calculate string length

  instance_type_length = length(
    var.instance_type
  )
}

resource "aws_instance" "validation_demo" {

  ami = "ami-091138d0f0d41ff90"

  instance_type = var.instance_type

  tags = {

    Name = "instance-validation-demo"

    Environment = "dev"

    ManagedBy = "Terraform"

  }

  lifecycle {

    precondition {

      condition = local.valid_instance_type

      error_message = "Instance type must start with 't3.'"
    }
  }
}