
# =============================================================================
# Data Source
# =============================================================================

data "aws_region" "current" {}

# =============================================================================
# Example: precondition
# =============================================================================
# Purpose:
# Allow deployments only in approved AWS regions.
#
# Test:
# Change aws_region to an unsupported region
# and observe Terraform validation failure.
# =============================================================================

resource "aws_s3_bucket" "regional_validation" {

  bucket = var.bucket_name

  lifecycle {

    precondition {

      condition = contains(
        var.allowed_regions,
        data.aws_region.current.name
      )

      error_message = "ERROR: Deployment is allowed only in ${join(", ", var.allowed_regions)}"

    }

  }

  tags = {
    Name        = "Precondition-Demo"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}