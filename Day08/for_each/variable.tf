# Bucket names for FOR_EACH example

variable "bucket_name_foreach" {
  description = "Set of bucket names"
  type        = set(string)

  default = [
    "ramana-foreach-001",
    "ramana-foreach-002",
    "ramana-foreach-003"
  ]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}