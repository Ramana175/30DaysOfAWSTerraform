# Assignment 07 - Backup Configuration Using Terraform Functions

## Overview

Managing backups is a critical part of cloud infrastructure.

Organizations often enforce backup naming standards and ensure sensitive credentials are protected from accidental exposure.

This assignment demonstrates how Terraform functions can validate backup file formats and securely handle sensitive information.

---

# Learning Objectives

By completing this assignment, you will learn:

* How to use `endswith()`
* How to use `sensitive()`
* How to validate file naming conventions
* How to protect sensitive information
* Security best practices in Terraform

---

# Real-World Problem

Imagine a backup automation system expects all backup files to be compressed ZIP files.

Valid:

```text
database-backup.zip
application-backup.zip
```

Invalid:

```text
database-backup.txt
database-backup.docx
```

At the same time, backup encryption passwords must not be visible in Terraform outputs.

Without controls:

❌ Invalid backup files may be processed

❌ Passwords may be exposed

❌ Security risks increase

❌ Compliance requirements may be violated

---

# Solution

Terraform provides functions to validate values and protect sensitive information.

Functions Used:

* `endswith()`
* `sensitive()`

---

# Function Explained

## endswith()

Checks whether a string ends with a specified suffix.

Example:

```hcl
endswith(
  "database-backup.zip",
  ".zip"
)
```

Output:

```text
true
```

---

## sensitive()

Marks a value as sensitive.

Example:

```hcl
sensitive(
  "MySecretPassword123"
)
```

Terraform Output:

```text
(sensitive value)
```

---

# How It Works

Input:

```text
database-backup.zip
```

Terraform:

```text
endswith()
```

Result:

```text
true
```

---

Input:

```text
database-backup.txt
```

Terraform:

```text
endswith()
```

Result:

```text
false
```

---

Password:

```text
MySecretPassword123
```

Terraform:

```text
sensitive()
```

Result:

```text
(sensitive value)
```

---

# Internal Workflow

```text
Backup File Name
        │
        ▼

database-backup.zip

        │
        ▼

endswith(".zip")

        │
        ▼

true

------------------------------------------------

Password

        │
        ▼

MySecretPassword123

        │
        ▼

sensitive()

        │
        ▼

(sensitive value)
```

---

# Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Validate:

```bash
terraform validate
```

Plan:

```bash
terraform plan
```

Deploy:

```bash
terraform apply --auto-approve
```

View Outputs:

```bash
terraform output
```

---

# Example Output

```text
backup_file_name = "database-backup.zip"

backup_file_validation = true

backup_password = (sensitive value)
```

---

# Real-World Use Cases

### Database Backups

Validate backup file formats.

### Secret Management

Protect passwords and tokens.

### Encryption Keys

Prevent exposure of sensitive values.

### Compliance Requirements

Meet security standards.

### Infrastructure Security

Reduce accidental credential leakage.

---

# Benefits

✅ Improved security

✅ Sensitive data protection

✅ Backup validation

✅ Reduced operational risk

✅ Better compliance

---

# Interview Question

### What is the purpose of sensitive() in Terraform?

The `sensitive()` function marks values as sensitive, preventing Terraform from displaying them in command outputs and logs.

Example:

```hcl
sensitive(var.database_password)
```

Output:

```text
(sensitive value)
```

---

# Key Takeaways

* `endswith()` validates string endings.
* `sensitive()` hides confidential values.
* Useful for backups and secret management.
* Improves Terraform security.
* Supports compliance and governance requirements.

---

# Skills Demonstrated

* Terraform Functions
* endswith()
* sensitive()
* Secret Management
* Infrastructure Security
* DevOps Best Practices

### Assignment Status

✅ Completed

### Functions Covered

* endswith()
* sensitive()

### Difficulty

⭐⭐ Intermediate

Part of the **#30DaysOfAWSTerraform** challenge.
