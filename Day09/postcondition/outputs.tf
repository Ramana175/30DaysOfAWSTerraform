output "bucket_name" {
  description = "Created bucket name"
  value       = aws_s3_bucket.compliance_bucket.bucket
}

output "bucket_arn" {
  description = "Bucket ARN"
  value       = aws_s3_bucket.compliance_bucket.arn
}