# -----------------------------------------------------------------------------
# COUNT Example
# -----------------------------------------------------------------------------
# Creates multiple S3 buckets using count.
# Resources are addressed using indexes:
# aws_s3_bucket.example_count[0]
# aws_s3_bucket.example_count[1]
# aws_s3_bucket.example_count[2]
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "example_count" {

  count = length(var.bucket_name)

  bucket = var.bucket_name[count.index]

  tags = {
    bucket_name = var.bucket_name[count.index]
    Environment = var.environment
    index       = tostring(count.index)
    managed_by  = "terraform"
    bucketType  = "count"
  }
}