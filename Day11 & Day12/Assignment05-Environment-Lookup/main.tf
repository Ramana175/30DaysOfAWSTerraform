# =============================================================================
# Assignment 05: Environment Lookup
# =============================================================================
# Purpose:
# Dynamically select EC2 instance types based on environment.
#
# Problem:
# Different environments require different resources.
#
# Example:
#
# dev  -> t3.micro
# test -> t3.small
# prod -> t3.medium
#
# Function Used:
# - lookup()
#
# Real-World Use Cases:
# - Environment Specific Configurations
# - EC2 Instance Selection
# - RDS Instance Sizing
# - Auto Scaling Configuration
# =============================================================================

locals {

  instance_types = {

    dev  = "t3.micro"

    test = "t3.small"

    prod = "t3.medium"

  }

  selected_instance_type = lookup(
    local.instance_types,
    var.environment,
    "t3.micro"
  )
}

resource "aws_instance" "environment_demo" {

  ami = "ami-091138d0f0d41ff90"

  instance_type = local.selected_instance_type

  tags = {

    Name = "${var.environment}-server"

    Environment = var.environment

    ManagedBy = "Terraform"

  }
}