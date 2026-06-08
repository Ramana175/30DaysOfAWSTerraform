# =============================================================================
# Outputs
# =============================================================================

output "original_project_name" {

  description = "Original Project Name"

  value = var.project_name
}

output "generated_bucket_name" {

  description = "Generated S3 Bucket Name"

  value = aws_s3_bucket.project_bucket.bucket
}