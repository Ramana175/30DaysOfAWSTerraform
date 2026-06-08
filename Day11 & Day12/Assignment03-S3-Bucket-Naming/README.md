# Assignment 03 - S3 Bucket Naming Using Terraform Functions

## Overview

Naming cloud resources correctly is an important part of Infrastructure as Code.

AWS S3 bucket names must follow strict naming rules:

* Must be lowercase
* Cannot contain spaces
* Must be globally unique
* Should be easy to identify

This assignment demonstrates how Terraform functions can automatically generate AWS-compliant bucket names.

---

# Learning Objectives

By completing this assignment, you will learn:

* How to use Terraform String Functions
* How to generate AWS-compliant names
* How to standardize resource naming
* How to automate naming conventions
* Real-world Terraform naming practices

---

# Real-World Problem

Imagine multiple engineers creating buckets manually.

Examples:

```text
My Production Application Bucket
my production application bucket
MY_PRODUCTION_BUCKET
My-App-Bucket
```

These names are inconsistent and may violate AWS naming requirements.

This can lead to:

❌ Deployment failures

❌ Inconsistent infrastructure

❌ Poor governance

❌ Difficult automation

---

# Solution

Terraform String Functions can automatically transform resource names into a valid format.

Functions Used:

* lower()
* replace()
* substr()

Input:

```text
My Production Application Bucket
```

Terraform:

```hcl
lower(
  replace(
    substr(var.project_name, 0, 25),
    " ",
    "-"
  )
)
```

Output:

```text
my-production-applicat
```

---

# Functions Explained

## substr()

Extracts a portion of a string.

Example:

```hcl
substr(
  "My Production Application Bucket",
  0,
  25
)
```

Output:

```text
My Production Applicat
```

---

## replace()

Replaces characters within a string.

Example:

```hcl
replace(
  "My Production Applicat",
  " ",
  "-"
)
```

Output:

```text
My-Production-Applicat
```

---

## lower()

Converts text to lowercase.

Example:

```hcl
lower(
  "My-Production-Applicat"
)
```

Output:

```text
my-production-applicat
```

---

# How It Works

```text
Project Name
      │
      ▼

My Production Application Bucket

      │
      ▼

substr()

      │
      ▼

My Production Applicat

      │
      ▼

replace()

      │
      ▼

My-Production-Applicat

      │
      ▼

lower()

      │
      ▼

my-production-applicat
```

---

# Deployment Steps

Initialize:

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

Apply:

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
original_project_name = "My Production Application Bucket"

generated_bucket_name = "my-production-applicat-2026"
```

---

# Real-World Use Cases

### S3 Bucket Naming

```text
project-logs-dev
project-backups-prod
project-artifacts-test
```

### IAM Resource Naming

```text
project-admin-role
project-readonly-role
```

### Kubernetes Resources

```text
project-api-deployment
project-backend-service
```

### Multi-Environment Deployments

```text
app-dev
app-test
app-prod
```

---

# Benefits

✅ Consistent naming

✅ AWS-compliant resources

✅ Reduced human error

✅ Better governance

✅ Easier automation

---

# Interview Question

### Why use Terraform functions for resource naming?

Terraform functions automate naming standards, ensure compliance with cloud provider requirements, reduce manual effort, and improve infrastructure consistency.

---

# Key Takeaways

* `substr()` extracts part of a string.
* `replace()` substitutes characters.
* `lower()` converts text to lowercase.
* Combining functions creates AWS-compliant resource names.
* Naming standards are critical in production environments.

---

# Skills Demonstrated

* Terraform Functions
* AWS S3
* String Manipulation
* Infrastructure as Code
* Cloud Governance
* DevOps Best Practices

### Assignment Status

✅ Completed

### Functions Covered

* lower()
* replace()
* substr()

### Difficulty

⭐⭐ Beginner to Intermediate

Part of the **#30DaysOfAWSTerraform** challenge.
