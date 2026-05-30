# -----------------------------------------------------------------------------
# FOR_EACH Example
# -----------------------------------------------------------------------------
# Creates multiple S3 buckets using for_each.
# Resources are addressed using keys:
# aws_s3_bucket.example_foreach["ramana-foreach-001"]
# aws_s3_bucket.example_foreach["ramana-foreach-002"]
# aws_s3_bucket.example_foreach["ramana-foreach-003"]
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "example_foreach" {

  for_each = var.bucket_name_foreach

  bucket = each.value

  tags = {
    bucket_name = each.value
    Environment = var.environment
    managed_by  = "terraform"
    bucketType  = "foreach"
  }
}