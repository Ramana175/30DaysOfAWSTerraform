# =============================================================================
# Assignment 12: File Content Handling
# =============================================================================
# Purpose:
# Read external JSON configuration files
# and convert them into Terraform objects.
#
# Functions Used:
# - file()
# - jsondecode()
#
# Real-World Use Cases:
# - Application Configuration
# - Environment Variables
# - Infrastructure Settings
# - Secrets Management
# =============================================================================

locals {

  # Read JSON File

  config_file = file(
    "${path.module}/config.json"
  )

  # Convert JSON to Terraform Object

  config = jsondecode(
    local.config_file
  )

}

resource "aws_instance" "demo_server" {

  ami = "ami-091138d0f0d41ff90"

  instance_type = local.config.instance_type

  tags = {

    Name = "${local.config.project}-${local.config.environment}"

    Environment = local.config.environment

    Owner = local.config.owner

  }

}