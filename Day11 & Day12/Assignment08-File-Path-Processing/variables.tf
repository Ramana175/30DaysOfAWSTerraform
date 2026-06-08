# =============================================================================
# Assignment 08: File Path Processing
# =============================================================================
# Purpose:
# Store file path information.
# =============================================================================

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-1"
}

variable "config_file_path" {

  description = "Configuration file path"

  type = string

  default = "config.json"
}