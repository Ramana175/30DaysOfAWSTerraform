# =============================================================================
# Assignment 2: Resource Tagging
# =============================================================================
# Purpose:
# Define common and project-specific tags.
# =============================================================================

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-1"
}

variable "environment" {

  description = "Environment Name"

  type = string

  default = "dev"
}

variable "project_name" {

  description = "Project Name"

  type = string

  default = "Terraform Functions"
}

variable "owner" {

  description = "Resource Owner"

  type = string

  default = "Ramana"
}