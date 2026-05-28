resource "random_id" "suffix" {
  byte_length = 4

  keepers = {
    project     = var.project_name
    environment = var.environment
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  bucket_name = "${local.name_prefix}-${random_id.suffix.hex}"
  vpc_name    = "${local.name_prefix}-vpc"

  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  })
}