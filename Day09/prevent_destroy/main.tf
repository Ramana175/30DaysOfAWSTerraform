# =============================================================================
# Example 2: prevent_destroy
# =============================================================================
# Purpose:
# Prevent accidental deletion of critical resources.
#
# Use Cases:
# - Production databases
# - Terraform state buckets
# - Critical backups
# - Compliance resources
#
# Expected Behavior:
# terraform destroy
#      ↓
# Terraform throws an error
#      ↓
# Resource remains protected
# =============================================================================

resource "aws_s3_bucket" "critical_data" {

  bucket = var.bucket_name

  tags = {
    Name        = "Critical-Data-Bucket"
    Environment = var.environment
    Demo        = "prevent_destroy"
  }

  lifecycle {
    prevent_destroy = true
  }
}