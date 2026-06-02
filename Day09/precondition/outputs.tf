# =============================================================================
# Outputs
# =============================================================================

output "bucket_name" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.regional_validation.bucket
}

output "current_region" {
  description = "Current AWS Region"
  value       = data.aws_region.current.name
}