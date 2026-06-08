# =============================================================================
# Assignment 07: Backup Configuration
# =============================================================================
# Purpose:
# Validate backup file extensions and protect sensitive data.
#
# Problem:
# Backup files should follow approved formats.
# Passwords should never be displayed in outputs.
#
# Functions Used:
# - endswith()
# - sensitive()
#
# Example:
#
# Valid:
# database-backup.zip
# app-backup.zip
#
# Invalid:
# backup.txt
# backup.doc
#
# Real-World Use Cases:
# - Backup Validation
# - Secret Management
# - Database Credentials
# - Infrastructure Security
# =============================================================================

locals {

  valid_backup_file = endswith(
    var.backup_file_name,
    ".zip"
  )

  protected_password = sensitive(
    var.backup_password
  )
}