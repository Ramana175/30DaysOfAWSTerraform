# Day 09 - Terraform Lifecycle Meta-Argument: ignore_changes

## Overview

This project demonstrates the Terraform lifecycle meta-argument **ignore_changes**.

The `ignore_changes` rule tells Terraform to ignore modifications made to specific resource attributes. When enabled, Terraform will not attempt to revert those changes during future plans or applies.

This is useful when certain resource attributes are managed outside Terraform by AWS services, monitoring tools, auto-scaling policies, or other teams.

---

# Learning Objectives

By completing this project, you will learn:

* What `ignore_changes` is
* How Terraform handles configuration drift
* How to ignore specific resource attributes
* How to allow external systems to manage resources
* Real-world use cases of `ignore_changes`

---

# Project Structure

```text
ignore_changes/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── README.md
```

---

# What is ignore_changes?

Normally, Terraform tries to keep infrastructure exactly matching the code.

Example:

Terraform Code:

```text
Name = demo-server
Environment = dev
```

Someone manually adds:

```text
Owner = DevOps-Team
```

Terraform detects this drift and tries to remove it.

With:

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

Terraform ignores the change and leaves the tag untouched.

---

# Why Do We Need It?

In real-world environments, resources are often modified by:

* Auto Scaling Policies
* Monitoring Tools
* Security Teams
* AWS Services
* External Automation Tools

Without `ignore_changes`, Terraform repeatedly tries to undo those changes.

With `ignore_changes`, Terraform allows those systems to manage selected attributes.

---

# Complete Example

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

### How it works

* Configures AWS as the cloud provider.
* Deploys resources in the specified AWS region.

---

## variables.tf

```hcl
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "EC2 Instance Name"
  type        = string
  default     = "ignore-changes-demo"
}
```

### How it works

| Variable      | Purpose                   |
| ------------- | ------------------------- |
| aws_region    | AWS region for deployment |
| instance_type | EC2 instance size         |
| instance_name | Name of the EC2 instance  |

---

## main.tf

```hcl
# =============================================================================
# Example: ignore_changes
# =============================================================================
# Purpose:
# Ignore changes made to EC2 tags outside Terraform.
# =============================================================================

resource "aws_instance" "demo_server" {

  ami           = "ami-091138d0f0d41ff90"
  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    Environment = "dev"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
```

### How it works

Terraform creates:

```text
aws_instance.demo_server
```

The lifecycle block:

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

tells Terraform:

> Ignore any changes made to EC2 tags.

---

## outputs.tf

```hcl
output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.demo_server.id
}

output "public_ip" {
  description = "Public IP Address"
  value       = aws_instance.demo_server.public_ip
}
```

### How it works

Displays important information after deployment.

Example:

```bash
terraform output
```

Output:

```text
instance_id = "i-0123456789abcdef"
public_ip   = "54.123.45.67"
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
EC2 Instance Created
      │
      ▼
Manual Tag Change
      │
      ▼
Terraform Plan
      │
      ▼
No Changes Detected
```

---

# Practical Demonstration

## Step 1 - Create EC2 Instance

```bash
terraform init
terraform validate
terraform apply --auto-approve
```

Expected:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

## Step 2 - Add Tag Manually

Open AWS Console:

EC2 → Instances → Select Instance → Tags → Manage Tags

Add:

```text
Key   = Owner
Value = DevOps-Team
```

Save the changes.

---

## Step 3 - Run Terraform Plan

```bash
terraform plan
```

Expected:

```text
No changes.
Your infrastructure matches the configuration.
```

Terraform ignores the manually added tag.

---

# What Happens Without ignore_changes?

Remove:

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

Run:

```bash
terraform plan
```

Terraform detects drift:

```text
~ tags
    - Owner = "DevOps-Team" -> null
```

Terraform wants to remove the manually added tag.

---

# What Happens With ignore_changes?

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

Run:

```bash
terraform plan
```

Output:

```text
No changes.
```

Terraform ignores the tag modification.

---

# Real-World Example: Auto Scaling

```hcl
resource "aws_autoscaling_group" "app_servers" {

  desired_capacity = 2

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }
}
```

### Why?

Auto Scaling automatically changes:

```text
2 → 4 → 8 → 3
```

based on application load.

Without `ignore_changes`:

```text
Terraform tries to reset capacity back to 2
```

With `ignore_changes`:

```text
Terraform allows Auto Scaling to manage capacity
```

---

# Special Values

Ignore specific attributes:

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

Ignore multiple attributes:

```hcl
lifecycle {
  ignore_changes = [
    tags,
    user_data
  ]
}
```

Ignore all attributes:

```hcl
lifecycle {
  ignore_changes = all
}
```

---

# Benefits

✅ Prevents unnecessary Terraform updates

✅ Reduces configuration drift issues

✅ Allows external systems to manage attributes

✅ Cleaner Terraform plans

✅ Supports hybrid management approaches

---

# Common Use Cases

* Auto Scaling Groups
* Monitoring Tool Tags
* AWS Managed Attributes
* Database Passwords Managed by Secrets Manager
* Security Rules Managed by Other Teams
* Frequently Changing Values

---

# Interview Question

### What is ignore_changes in Terraform?

`ignore_changes` is a lifecycle meta-argument that tells Terraform to ignore changes made to specific resource attributes. It is commonly used when those attributes are managed by external systems such as Auto Scaling, monitoring tools, AWS services, or other teams.

---

# Lifecycle Meta-Arguments Summary

| Lifecycle Rule        | Purpose                                               |
| --------------------- | ----------------------------------------------------- |
| create_before_destroy | Create replacement resource before destroying old one |
| prevent_destroy       | Prevent accidental deletion                           |
| ignore_changes        | Ignore selected attribute changes                     |

---

# Key Takeaways

* `ignore_changes` prevents Terraform from reverting specific changes.
* Useful when resources are managed by multiple systems.
* Helps reduce Terraform plan noise.
* Commonly used with Auto Scaling Groups and externally managed tags.
* Supports real-world enterprise infrastructure management.

---

# Skills Demonstrated

* Terraform Lifecycle Meta-Arguments
* AWS EC2
* Infrastructure as Code (IaC)
* Configuration Drift Management
* Cloud Resource Governance
* Terraform Best Practices
* Infrastructure Automation
