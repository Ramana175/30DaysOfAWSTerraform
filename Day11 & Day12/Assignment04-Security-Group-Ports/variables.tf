# =============================================================================
# Assignment 04: Security Group Ports
# =============================================================================
# Purpose:
# Store ports as a comma-separated string.
# =============================================================================

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-1"
}

variable "allowed_ports" {

  description = "Comma separated list of ports"

  type = string

  default = "22,80,443,8080"
}