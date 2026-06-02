# =============================================================================
# Terraform Configuration
# =============================================================================
# Defines:
# - Required Terraform version
# - Required AWS Provider version
#
# Benefits:
# - Ensures compatibility across environments
# - Prevents unexpected behavior due to version changes
# =============================================================================

terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
}

# =============================================================================
# AWS Provider Configuration
# =============================================================================
# Specifies:
# - AWS Region
# - Default Tags
#
# Default tags are automatically applied to all supported
# AWS resources created by Terraform.
# =============================================================================

provider "aws" {

  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = "Day09-Lifecycle-Demo"
    }
  }
}