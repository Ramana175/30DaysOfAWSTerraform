variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "bucket" {
    type = string
    default = "ramana-static-web-hosting175"
  
}