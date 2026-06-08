# =============================================================================
# Assignment 1: Project Naming
# =============================================================================
# Purpose:
# Input variable containing the project name.
#
# Example Input:
# Project ALPHA Resource
# =============================================================================

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-1"
}

variable "project_name" {

  description = "Project Name"

  type = string

  default = "Project ALPHA Resource"
}