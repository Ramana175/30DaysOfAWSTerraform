# =============================================================================
# Assignment 09: Location Management
# =============================================================================
# Purpose:
# Store AWS regions from different business units.
# =============================================================================

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-1"
}

variable "primary_regions" {

  description = "Primary deployment regions"

  type = list(string)

  default = [
    "us-east-1",
    "us-west-2"
  ]
}

variable "secondary_regions" {

  description = "Secondary deployment regions"

  type = list(string)

  default = [
    "us-west-2",
    "eu-west-1",
    "ap-south-1"
  ]
}