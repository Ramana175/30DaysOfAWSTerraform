# =============================================================================
# Assignment 06: Instance Validation
# =============================================================================
# Purpose:
# Validate EC2 instance type before deployment.
# =============================================================================

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-1"
}

variable "instance_type" {

  description = "EC2 Instance Type"

  type = string

  default = "t3.micro"
}