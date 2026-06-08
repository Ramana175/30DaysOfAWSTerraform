# =============================================================================
# Assignment 11: Timestamp Management
# =============================================================================
# Purpose:
# Generate deployment timestamps and formatted dates.
#
# Functions Used:
# - timestamp()
# - formatdate()
#
# Real-World Use Cases:
# - Deployment Tracking
# - Backup Naming
# - Audit Logging
# - Resource Versioning
# =============================================================================

locals {

  current_timestamp = timestamp()

  formatted_date = formatdate(
    "DD-MMM-YYYY",
    local.current_timestamp
  )

  formatted_time = formatdate(
    "hh:mm ZZZ",
    local.current_timestamp
  )

}

resource "aws_s3_bucket" "backup_bucket" {

  bucket = "terraform-backup-demo-${formatdate("YYYYMMDD", local.current_timestamp)}"

  tags = {

    Name = "Backup Bucket"

    CreatedDate = local.formatted_date

    ManagedBy = "Terraform"

  }

}