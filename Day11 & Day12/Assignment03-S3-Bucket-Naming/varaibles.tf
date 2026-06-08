# =============================================================================
# Assignment 03: S3 Bucket Naming
# =============================================================================
# Purpose:
# Input variables used for generating
# AWS-compliant bucket names.
# =============================================================================

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-1"
}

variable "project_name" {

  description = "Project Name"

  type = string

  default = "My Production Application Bucket"
}