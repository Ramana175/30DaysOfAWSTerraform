# Day 09 - Terraform Lifecycle Meta-Argument: prevent_destroy

## Overview

This project demonstrates the Terraform lifecycle meta-argument **prevent_destroy**.

The `prevent_destroy` lifecycle rule is used to protect critical infrastructure resources from accidental deletion. When enabled, Terraform prevents destroy operations and returns an error if someone attempts to delete the resource.

This feature is commonly used in production environments to protect important resources such as databases, backup storage, Terraform state buckets, and compliance-related infrastructure.

---

# Learning Objectives

By completing this project, you will learn:

* What Terraform lifecycle meta-arguments are
* How `prevent_destroy` works
* How Terraform protects critical resources
* How to prevent accidental deletion
* Real-world production use cases
* Infrastructure safety best practices

---

# Project Structure

```text
prevent_destroy/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── README.md
```

---

# What is prevent_destroy?

`prevent_destroy` is a Terraform lifecycle rule that prevents a resource from being destroyed.

When Terraform detects a destroy operation on a protected resource, it immediately stops execution and returns an error.

Example:

```hcl
lifecycle {
  prevent_destroy = true
}
```

---

# Why Do We Need It?

Imagine your organization stores important business data in an S3 bucket.

Examples:

* Customer Backups
* Application Logs
* Database Dumps
* Recovery Files
* Terraform State Files

Accidentally deleting these resources can result in:

❌ Data Loss

❌ Service Disruption

❌ Compliance Issues

❌ Recovery Challenges

To prevent such situations, Terraform provides the `prevent_destroy` lifecycle rule.

---

# Complete Example

## provider.tf

The provider configuration tells Terraform which cloud provider to use.

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

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = "prevent-destroy-demo"
    }
  }
}
```

### How it works

* Uses AWS as the cloud provider
* Deploys resources in the specified AWS region
* Automatically applies common tags to resources

---

## variables.tf

Variables make Terraform configurations reusable and flexible.

```hcl
variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "bucket_name" {
  description = "Critical S3 bucket name"
  type        = string
  default     = "ramana-prevent-destroy-demo-001"
}
```

### How it works

| Variable    | Purpose                                    |
| ----------- | ------------------------------------------ |
| aws_region  | AWS region where resources will be created |
| environment | Environment identifier                     |
| bucket_name | Name of the S3 bucket                      |

---

## main.tf

Creates a protected S3 bucket.

```hcl
resource "aws_s3_bucket" "critical_data" {

  bucket = var.bucket_name

  tags = {
    Name        = "Critical-Data-Bucket"
    Environment = var.environment
    Demo        = "prevent_destroy"
  }

  lifecycle {
    prevent_destroy = true
  }
}
```

### How it works

Terraform creates:

```text
aws_s3_bucket.critical_data
```

The lifecycle block:

```hcl
lifecycle {
  prevent_destroy = true
}
```

acts as a protection layer and prevents accidental deletion.

---

## outputs.tf

Outputs display resource information after deployment.

```hcl
output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.critical_data.bucket
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.critical_data.arn
}
```

### How it works

After deployment:

```bash
terraform output
```

Example:

```text
bucket_name = "ramana-prevent-destroy-demo-001"

bucket_arn = "arn:aws:s3:::ramana-prevent-destroy-demo-001"
```

---

# End-to-End Workflow

```text
variables.tf
      │
      ▼
provider.tf
      │
      ▼
main.tf
      │
      ▼
Terraform Apply
      │
      ▼
AWS S3 Bucket Created
      │
      ▼
outputs.tf
      │
      ▼
Display Bucket Information
```

---

# Terraform Commands

## Initialize Terraform

```bash
terraform init
```

Downloads required providers and initializes the working directory.

---

## Validate Configuration

```bash
terraform validate
```

Checks Terraform syntax and configuration.

Expected:

```text
Success! The configuration is valid.
```

---

## Review Execution Plan

```bash
terraform plan
```

Shows what Terraform intends to create.

Example:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

---

## Create Resources

```bash
terraform apply --auto-approve
```

Example:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

## Verify Outputs

```bash
terraform output
```

Example:

```text
bucket_name = "ramana-prevent-destroy-demo-001"

bucket_arn = "arn:aws:s3:::ramana-prevent-destroy-demo-001"
```

---

# Practical Demonstration

## Step 1 - Create Bucket

```bash
terraform apply --auto-approve
```

Terraform creates the bucket successfully.

---

## Step 2 - Attempt Destroy

```bash
terraform destroy --auto-approve
```

Terraform checks lifecycle rules.

It finds:

```hcl
prevent_destroy = true
```

Terraform immediately stops the operation.

---

# Expected Error

```text
Error: Instance cannot be destroyed

Resource aws_s3_bucket.critical_data has lifecycle.prevent_destroy set.
```

The resource remains protected.

---

# Internal Workflow

```text
terraform destroy
        │
        ▼
Terraform checks resource
        │
        ▼
prevent_destroy = true ?
        │
   Yes  ▼
        │
Stop Execution
        │
Return Error
        ▼
Resource Remains Safe
```

---

# Without prevent_destroy

```hcl
resource "aws_s3_bucket" "critical_data" {

  bucket = var.bucket_name
}
```

Destroy command:

```bash
terraform destroy
```

Result:

```text
Bucket Deleted Successfully
```

---

# With prevent_destroy

```hcl
resource "aws_s3_bucket" "critical_data" {

  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}
```

Destroy command:

```bash
terraform destroy
```

Result:

```text
Terraform Error
Resource Protected
```

---

# Real-World Use Cases

## Production Database

```hcl
resource "aws_db_instance" "prod_db" {

  lifecycle {
    prevent_destroy = true
  }
}
```

Purpose:

Protect customer and business data.

---

## Terraform State Bucket

```hcl
resource "aws_s3_bucket" "terraform_state" {

  lifecycle {
    prevent_destroy = true
  }
}
```

Purpose:

Protect Terraform state files.

---

## Backup Storage

```hcl
resource "aws_s3_bucket" "backup_bucket" {

  lifecycle {
    prevent_destroy = true
  }
}
```

Purpose:

Protect disaster recovery backups.

---

## Security Groups

```hcl
resource "aws_security_group" "prod_sg" {

  lifecycle {
    prevent_destroy = true
  }
}
```

Purpose:

Prevent accidental deletion of production network controls.

---

# Benefits

✅ Protects critical resources

✅ Prevents accidental deletion

✅ Reduces operational risk

✅ Protects important data

✅ Helps maintain compliance

✅ Adds a safety layer to infrastructure

---

# Limitations

⚠️ Resource cannot be destroyed until protection is removed

⚠️ May block changes that require resource replacement

⚠️ Should be used only for truly critical resources

---

# How to Remove Protection

Remove:

```hcl
lifecycle {
  prevent_destroy = true
}
```

Apply the change:

```bash
terraform apply
```

Then:

```bash
terraform destroy
```

The resource can now be deleted.

---

# Interview Question

### What is prevent_destroy in Terraform?

`prevent_destroy` is a lifecycle meta-argument that prevents Terraform from deleting a resource. If a destroy operation is attempted, Terraform stops execution and returns an error. It is commonly used to protect production databases, Terraform state buckets, backup storage, and other critical infrastructure resources.

---

# Key Takeaways

* `prevent_destroy` protects resources from accidental deletion.
* Terraform blocks destroy operations on protected resources.
* Commonly used for production and stateful resources.
* Adds an extra safety layer to Infrastructure as Code.
* Helps prevent data loss and operational incidents.

---

# Skills Demonstrated

* Terraform Lifecycle Meta-Arguments
* AWS S3
* Infrastructure as Code (IaC)
* Resource Protection
* Terraform Variables
* Terraform Outputs
* Infrastructure Governance
* Production Safety Controls
* Cloud Infrastructure Management
