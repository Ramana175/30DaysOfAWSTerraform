# =============================================================================
# Outputs
# =============================================================================

output "backup_file_name" {

  description = "Backup File Name"

  value = var.backup_file_name
}

output "backup_file_validation" {

  description = "Backup File Validation Result"

  value = local.valid_backup_file
}

output "backup_password" {

  description = "Sensitive Backup Password"

  value     = local.protected_password
  sensitive = true
}