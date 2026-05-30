output "bucket_names" {
  value = [
    for bucket in aws_s3_bucket.example_count :
    bucket.bucket
  ]
}

output "bucket_ids" {
  value = [
    for bucket in aws_s3_bucket.example_count :
    bucket.id
  ]
}