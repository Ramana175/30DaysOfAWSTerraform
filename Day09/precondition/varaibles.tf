# =============================================================================
# AWS Region
# =============================================================================

variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

# =============================================================================
# Allowed Regions
# =============================================================================

variable "allowed_regions" {
  description = "Regions approved by the organization"
  type        = list(string)

  default = [
    "us-east-1",
    "us-west-2"
  ]
}

# =============================================================================
# Bucket Name
# =============================================================================

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "ramana-precondition-demo-2026"
}