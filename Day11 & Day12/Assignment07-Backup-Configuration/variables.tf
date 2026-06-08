# =============================================================================
# Assignment 07: Backup Configuration
# =============================================================================
# Purpose:
# Store backup file information and sensitive credentials.
# =============================================================================

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-1"
}

variable "backup_file_name" {

  description = "Backup file name"

  type = string

  default = "database-backup.zip"
}

variable "backup_password" {

  description = "Backup encryption password"

  type = string

  default = "MySecretPassword123"
}