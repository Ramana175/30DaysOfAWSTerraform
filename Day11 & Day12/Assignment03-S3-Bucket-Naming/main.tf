# =============================================================================
# Assignment 03: S3 Bucket Naming
# =============================================================================
# Purpose:
# Generate AWS-compliant S3 bucket names.
#
# Problem:
# AWS S3 bucket names:
# - Must be lowercase
# - Cannot contain spaces
# - Should be concise
#
# Example Input:
# My Production Application Bucket
#
# Example Output:
# my-production-applicat
#
# Functions Used:
# - lower()
# - replace()
# - substr()
#
# Real-World Use Cases:
# - S3 Buckets
# - IAM Resource Names
# - Cloud Naming Standards
# - Multi-Environment Deployments
# =============================================================================

locals {

  bucket_name = lower(

    replace(

      substr(
        var.project_name,
        0,
        25
      ),

      " ",
      "-"

    )

  )
}

resource "aws_s3_bucket" "project_bucket" {

  bucket = "${local.bucket_name}-2026"

  tags = {
    Name        = local.bucket_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}