# -----------------------------------------------------------------------------
# Day 08 - Understanding Terraform Count Meta-Argument
# -----------------------------------------------------------------------------
# Objective:
# Create multiple AWS S3 buckets using a single resource block.
#
# Concepts Used:
# 1. count          -> Creates multiple instances of a resource.
# 2. count.index    -> Provides the current resource index.
# 3. list(string)   -> Stores multiple bucket names.
# 4. tags           -> Adds metadata to AWS resources.
#
# Expected Result:
# Terraform will create 3 S3 buckets using a single resource block.
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "example_count" {

  # Create one bucket for each item in the bucket_name list
  count = length(var.bucket_name)

  # Assign bucket name based on the current index
  bucket = var.bucket_name[count.index]

  tags = {

    # Store the bucket name as a tag
    bucket_name = var.bucket_name[count.index]

    # Environment for resource identification
    Environment = var.environment

    # Current resource instance number
    index = tostring(count.index)

    # Indicates the resource is managed by Terraform
    managed_by = "terraform"
  }
}




# -----------------------------------------------------------------------------
# Day 09 - Understanding Terraform for_each Meta-Argument
# -----------------------------------------------------------------------------
# Objective:
# Create multiple AWS S3 buckets using the for_each meta-argument.
#
# Concepts Used:
# 1. for_each    -> Creates one resource for each item in a collection.
# 2. each.key    -> Current key being processed.
# 3. each.value  -> Current value being processed.
# 4. set(string) -> Collection of unique string values.
#
# Difference from count:
# count creates resources using numeric indexes:
#   aws_s3_bucket.example[0]
#   aws_s3_bucket.example[1]
#
# for_each creates resources using actual values:
#   aws_s3_bucket.example["my-first-bucket"]
#   aws_s3_bucket.example["my-second-bucket"]
#
# for_each is preferred when resource names are unique and
# may be added or removed in the future.
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "example_foreach" {

  # Create one bucket for each item in the set
  for_each = var.bucket_name_foreach

  # Current bucket name
  bucket = each.value

  tags = {

    # Store bucket name as a tag
    bucket_name = each.value

    # Environment tag
    Environment = var.environment

    # Resource managed through Terraform
    managed_by = "terraform"

    # Indicates this resource uses for_each
    bucketType = "foreach"
  }
}