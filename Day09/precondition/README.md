# Day 09 - Terraform Lifecycle Meta-Argument: precondition

## Overview

This project demonstrates the Terraform lifecycle meta-argument **precondition**.

A `precondition` validates a condition before Terraform creates or updates a resource.

If the condition evaluates to `false`, Terraform immediately stops and displays a custom error message.

This helps prevent invalid deployments and enforce organizational standards.

---

# Learning Objectives

By completing this project, you will learn:

* What precondition is
* How Terraform validates resources before deployment
* How to enforce organizational policies
* How to create custom validation messages
* How to prevent invalid infrastructure deployments

---

# Project Structure

```text
precondition/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── README.md
```

---

# What is precondition?

A precondition is a validation rule that Terraform checks before creating or updating a resource.

Example:

```hcl
lifecycle {

  precondition {
    condition     = true
    error_message = "Validation failed"
  }

}
```

Terraform evaluates:

```text
Condition True ?
      │
      ├── Yes → Continue Deployment
      │
      └── No  → Stop Deployment
```

---

# Why Do We Need It?

Without validation:

```text
Wrong Configuration
        │
        ▼
Terraform Creates Resources
        │
        ▼
Deployment Issues
```

With precondition:

```text
Wrong Configuration
        │
        ▼
Precondition Check
        │
        ▼
Deployment Blocked
```

This prevents mistakes before infrastructure is created.

---

# Practical Example

## Scenario

Our company allows deployments only in:

```text
us-east-1
us-west-2
```

Any other region should fail.

---

## provider.tf

```hcl
terraform {

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

## variables.tf

```hcl
variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "allowed_regions" {
  description = "Regions approved by the organization"
  type        = list(string)

  default = [
    "us-east-1",
    "us-west-2"
  ]
}
```

---

## main.tf

```hcl
data "aws_region" "current" {}

resource "aws_s3_bucket" "regional_validation" {

  bucket = "ramana-precondition-demo-bucket"

  lifecycle {

    precondition {

      condition = contains(
        var.allowed_regions,
        data.aws_region.current.name
      )

      error_message = "ERROR: Deployment is allowed only in ${join(", ", var.allowed_regions)}"

    }

  }
}
```

---

## outputs.tf

```hcl
output "bucket_name" {
  value = aws_s3_bucket.regional_validation.bucket
}
```

---

# How It Works

Terraform first checks:

```hcl
contains(
  var.allowed_regions,
  data.aws_region.current.name
)
```

Suppose:

```text
Current Region = us-east-1
```

Terraform checks:

```text
Is us-east-1 in allowed_regions?
```

Result:

```text
TRUE
```

Deployment continues.

---

# Successful Deployment

Configuration:

```hcl
aws_region = "us-east-1"
```

Command:

```bash
terraform apply
```

Result:

```text
Apply complete!
Resources: 1 added.
```

---

# Failed Deployment

Configuration:

```hcl
aws_region = "ap-south-1"
```

Command:

```bash
terraform apply
```

Result:

```text
ERROR: Deployment is allowed only in us-east-1, us-west-2
```

Terraform stops immediately.

No resources are created.

---

# Internal Workflow

```text
terraform apply
        │
        ▼
Evaluate Precondition
        │
        ▼
Condition True?
        │
   ┌────┴────┐
   │         │
  Yes       No
   │         │
   ▼         ▼
Create    Error
Resource  Stop
```

---

# Another Example: Validate Bucket Name

```hcl
precondition {

  condition = length(var.bucket_name) > 10

  error_message = "Bucket name must be longer than 10 characters."

}
```

Purpose:

Ensure bucket names follow company standards.

---

# Another Example: Validate Environment

```hcl
precondition {

  condition = contains(
    ["dev", "test", "prod"],
    var.environment
  )

  error_message = "Environment must be dev, test, or prod."

}
```

Purpose:

Prevent invalid environment values.

---

# Benefits

✅ Prevents invalid deployments

✅ Enforces compliance requirements

✅ Provides clear error messages

✅ Catches problems early

✅ Reduces deployment failures

---

# Real-World Use Cases

### Region Validation

Prevent deployments in unauthorized regions.

---

### Environment Validation

Allow only approved environments.

---

### Naming Standards

Enforce naming conventions.

---

### Security Requirements

Validate encryption settings.

---

### Compliance Controls

Ensure company policies are followed.

---

# Interview Question

### What is precondition in Terraform?

`precondition` is a lifecycle validation rule that Terraform evaluates before creating or updating a resource. If the condition evaluates to false, Terraform stops execution and displays a custom error message. It is used to enforce policies, validate inputs, and prevent invalid infrastructure deployments.

---

# Lifecycle Meta-Arguments Summary

| Lifecycle Rule        | Purpose                                                  |
| --------------------- | -------------------------------------------------------- |
| create_before_destroy | Create replacement resource before deleting old resource |
| prevent_destroy       | Prevent accidental deletion                              |
| ignore_changes        | Ignore selected attribute changes                        |
| replace_triggered_by  | Force replacement when dependencies change               |
| precondition          | Validate conditions before resource creation             |

---

# Key Takeaways

* precondition validates resources before deployment.
* Prevents invalid configurations.
* Provides custom error messages.
* Helps enforce organizational standards.
* Improves deployment reliability and governance.

---

# Skills Demonstrated

* Terraform Lifecycle Meta-Arguments
* AWS S3
* Infrastructure Validation
* Infrastructure as Code (IaC)
* Policy Enforcement
* Cloud Governance
* Terraform Best Practices
