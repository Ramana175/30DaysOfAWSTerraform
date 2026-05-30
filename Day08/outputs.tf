# -----------------------------------------------------------------------------
# Output all bucket names created using count
# -----------------------------------------------------------------------------

output "bucket_names" {
  value = [
    for bucket in aws_s3_bucket.example_count :
    bucket.bucket
  ]
}

# -----------------------------------------------------------------------------
# Output all bucket IDs created using count
# -----------------------------------------------------------------------------

output "bucket_ids" {
  value = [
    for bucket in aws_s3_bucket.example_count :
    bucket.id
  ]
}