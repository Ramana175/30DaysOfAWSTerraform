# =============================================================================
# Example: postcondition
# =============================================================================
# Purpose:
# Validate that required tags exist AFTER resource creation.
#
# If the required tags are missing, Terraform throws an error.
# =============================================================================

resource "aws_s3_bucket" "compliance_bucket" {

  bucket = var.bucket_name

  tags = {
    Environment = "production"
    Compliance  = "SOC2"
  }

  lifecycle {

    postcondition {

      condition = contains(
        keys(self.tags),
        "Compliance"
      )

      error_message = "ERROR: Bucket must contain a Compliance tag."

    }

    postcondition {

      condition = contains(
        keys(self.tags),
        "Environment"
      )

      error_message = "ERROR: Bucket must contain an Environment tag."

    }

  }
}