# Bucket names for COUNT example

variable "bucket_name" {
  description = "List of bucket names"
  type        = list(string)

  default = [
    "ramana-count-001",
    "ramana-count-002",
    "ramana-count-003"
  ]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}