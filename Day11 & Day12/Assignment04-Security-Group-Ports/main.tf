# =============================================================================
# Assignment 04: Security Group Ports
# =============================================================================
# Purpose:
# Convert a comma-separated string of ports into a list
# and dynamically create Security Group ingress rules.
#
# Example Input:
# 22,80,443,8080
#
# Example Output:
# [22,80,443,8080]
#
# Functions Used:
# - split()
# - join()
# - for expression
#
# Real-World Use Cases:
# - Security Group Rules
# - Firewall Configurations
# - Dynamic Port Management
# =============================================================================

locals {

  # Convert string to list

  port_list = split(
    ",",
    var.allowed_ports
  )

  # Convert list back to string

  joined_ports = join(
    "-",
    local.port_list
  )

  # Convert string values to numbers

  numeric_ports = [
    for port in local.port_list :
    tonumber(port)
  ]
}

resource "aws_security_group" "web_sg" {

  name        = "terraform-function-sg"
  description = "Security Group created using Terraform Functions"

  dynamic "ingress" {

    for_each = local.numeric_ports

    content {

      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name      = "Assignment04-SG"
    ManagedBy = "Terraform"
  }
}