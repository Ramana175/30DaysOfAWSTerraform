# =============================================================================
# Assignment 05: Environment Lookup
# =============================================================================
# Purpose:
# Define deployment environment.
# =============================================================================

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-1"
}

variable "environment" {

  description = "Deployment Environment"

  type = string

  default = "dev"
}