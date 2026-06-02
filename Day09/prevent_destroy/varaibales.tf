# =============================================================================
# AWS Region
# =============================================================================

variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

# =============================================================================
# Environment
# =============================================================================

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

# =============================================================================
# S3 Bucket Name
# =============================================================================

variable "bucket_name" {
  description = "Critical S3 bucket name"
  type        = string
  default     = "ramana-prevent-destroy-demo-001"
}