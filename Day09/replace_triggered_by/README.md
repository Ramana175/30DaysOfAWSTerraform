# Day 09 - Terraform Lifecycle Meta-Argument: replace_triggered_by

## Overview

This project demonstrates the Terraform lifecycle meta-argument **replace_triggered_by**.

The `replace_triggered_by` rule forces Terraform to replace a resource when a specified dependency changes, even if the resource itself has not been modified.

This feature is useful in scenarios where infrastructure consistency requires a fresh deployment whenever a related resource changes.

---

# Learning Objectives

By completing this project, you will learn:

* What `replace_triggered_by` is
* How Terraform handles dependency-based replacements
* How to force resource recreation
* Immutable Infrastructure concepts
* Real-world use cases of dependency-driven deployments

---

# Project Structure

```text
replace_triggered_by/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── README.md
```

---

# What is replace_triggered_by?

Normally Terraform replaces a resource only when that resource changes.

Example:

```text
EC2 Instance
     │
     ▼
No Changes
     │
     ▼
No Replacement
```

However, sometimes another resource changes and we want Terraform to recreate the dependent resource.

Example:

```text
Security Group Updated
        │
        ▼
Recreate EC2 Instance
```

This behavior can be achieved using:

```hcl
lifecycle {
  replace_triggered_by = [
    aws_security_group.app_sg.id
  ]
}
```

---

# Why Do We Need It?

In many real-world deployments:

* Security Groups change
* Launch Templates change
* Application Configurations change
* Infrastructure Standards change

Although the EC2 instance itself has not changed, we may want a fresh deployment to ensure consistency.

This follows the **Immutable Infrastructure** approach.

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
```

### How it works

| Variable      | Purpose                   |
| ------------- | ------------------------- |
| aws_region    | AWS region for deployment |
| instance_type | EC2 instance size         |

---

## main.tf

```hcl
# =============================================================================
# Security Group
# =============================================================================

resource "aws_security_group" "app_sg" {

  name = "replace-trigger-demo"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# =============================================================================
# EC2 Instance
# =============================================================================

resource "aws_instance" "app_server" {

  ami           = "ami-091138d0f0d41ff90"
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  lifecycle {

    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]
  }

  tags = {
    Name = "replace-trigger-demo"
  }
}
```

### How it works

Terraform creates:

```text
aws_security_group.app_sg
aws_instance.app_server
```

The lifecycle block:

```hcl
lifecycle {

  replace_triggered_by = [
    aws_security_group.app_sg.id
  ]
}
```

tells Terraform:

> If the Security Group changes, replace the EC2 instance.

---

## outputs.tf

```hcl
output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.app_server.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.app_sg.id
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
instance_id       = "i-0123456789abcdef"
security_group_id = "sg-0123456789abcdef"
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
Security Group + EC2 Created
      │
      ▼
Security Group Modified
      │
      ▼
Terraform Plan
      │
      ▼
EC2 Marked For Replacement
```

---

# Practical Demonstration

## Step 1 - Deploy Resources

```bash
terraform init
terraform validate
terraform apply --auto-approve
```

Expected:

```text
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

---

## Step 2 - Save Instance ID

```bash
terraform output instance_id
```

Example:

```text
i-0123456789abcdef
```

---

## Step 3 - Modify Security Group

Change:

```hcl
from_port = 80
to_port   = 80
```

To:

```hcl
from_port = 8080
to_port   = 8080
```

---

## Step 4 - Run Terraform Plan

```bash
terraform plan
```

Expected:

```text
aws_security_group.app_sg will be updated

aws_instance.app_server must be replaced
```

Notice that the EC2 instance itself was not modified.

Terraform is replacing it because of:

```hcl
replace_triggered_by
```

---

## Step 5 - Apply Changes

```bash
terraform apply --auto-approve
```

Terraform creates a new EC2 instance.

Example:

```text
Old Instance:
i-0123456789abcdef

New Instance:
i-0987654321abcdef
```

---

# Internal Workflow

```text
Security Group Updated
          │
          ▼
replace_triggered_by Triggered
          │
          ▼
Terraform Marks EC2 For Replacement
          │
          ▼
New EC2 Instance Created
```

---

# Real-World Use Cases

## Security Group Updates

```hcl
replace_triggered_by = [
  aws_security_group.app_sg.id
]
```

Purpose:

Ensure EC2 instances are refreshed when security policies change.

---

## Launch Template Updates

```hcl
replace_triggered_by = [
  aws_launch_template.web.id
]
```

Purpose:

Deploy fresh instances using updated templates.

---

## Application Configuration Changes

```hcl
replace_triggered_by = [
  local_file.app_config
]
```

Purpose:

Ensure servers use updated configuration.

---

## Immutable Infrastructure

```text
Old Server
    │
    ▼
Destroy
    │
    ▼
Create Fresh Server
```

Purpose:

Avoid in-place modifications.

---

# Benefits

✅ Maintains infrastructure consistency

✅ Forces fresh deployments

✅ Supports immutable infrastructure

✅ Handles dependency-driven updates

✅ Improves deployment reliability

---

# Common Use Cases

* Security Group Changes
* Launch Template Updates
* Configuration Updates
* Infrastructure Rotation
* Immutable Infrastructure Patterns

---

# Interview Question

### What is replace_triggered_by in Terraform?

`replace_triggered_by` is a lifecycle meta-argument that forces Terraform to replace a resource when another specified resource or attribute changes, even if the resource itself has not changed. It is commonly used in immutable infrastructure patterns and dependency-driven deployments.

---

# Lifecycle Meta-Arguments Summary

| Lifecycle Rule        | Purpose                                                    |
| --------------------- | ---------------------------------------------------------- |
| create_before_destroy | Create replacement resource before destroying old resource |
| prevent_destroy       | Prevent accidental deletion                                |
| ignore_changes        | Ignore selected attribute changes                          |
| replace_triggered_by  | Force replacement when dependencies change                 |

---

# Key Takeaways

* `replace_triggered_by` forces resource replacement based on dependency changes.
* Useful for immutable infrastructure patterns.
* Helps maintain consistency across related resources.
* Commonly used with Security Groups, Launch Templates, and Configuration Updates.
* Ensures fresh deployments when dependencies change.

---

# Skills Demonstrated

* Terraform Lifecycle Meta-Arguments
* AWS EC2
* AWS Security Groups
* Infrastructure as Code (IaC)
* Immutable Infrastructure
* Dependency Management
* Cloud Infrastructure Automation
* Terraform Best Practices
