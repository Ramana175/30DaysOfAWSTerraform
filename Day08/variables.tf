# -----------------------------------------------------------------------------
# List of S3 bucket names
# Terraform uses count.index to access each bucket name.
# -----------------------------------------------------------------------------

variable "bucket_name" {
  description = "List of S3 bucket names"
  type        = list(string)

  default = [
    "ramana-count-001",
    "ramana-count-002",
    "ramana-count-003"
  ]
}



# -----------------------------------------------------------------------------
# Set of unique bucket names for for_each example
# -----------------------------------------------------------------------------

variable "bucket_name_foreach" {
  description = "List of S3 bucket names for foreach example"
  type        = set(string)

  default = [
    "ramana-foreach-001",
    "ramana-foreach-002",
    "ramana-foreach-003"
  ]
}




# -----------------------------------------------------------------------------
# Environment tag applied to all buckets
# -----------------------------------------------------------------------------

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}