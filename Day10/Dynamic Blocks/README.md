# Day 10 - Terraform Dynamic Blocks

## Overview

This project demonstrates **Terraform Dynamic Blocks** using an AWS Security Group.

Dynamic Blocks allow Terraform to generate multiple nested blocks automatically based on a collection such as a list, set, or map.

Instead of manually writing multiple ingress or egress blocks, Terraform dynamically creates them from input variables.

This approach reduces code duplication and improves maintainability.

---

# Learning Objectives

By completing this project, you will learn:

* What Dynamic Blocks are
* How Dynamic Blocks work
* How to generate Security Group rules dynamically
* How to use `for_each` inside Dynamic Blocks
* How to create reusable Terraform configurations
* Best practices for Dynamic Blocks

---

# What are Dynamic Blocks?

Dynamic Blocks allow Terraform to create multiple nested blocks automatically.

### Without Dynamic Blocks

```hcl
ingress {
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
}

ingress {
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
}

ingress {
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
}
```

This becomes repetitive.

---

### With Dynamic Blocks

```hcl
dynamic "ingress" {

  for_each = var.allowed_ports

  content {

    from_port = ingress.value
    to_port   = ingress.value
    protocol  = "tcp"

  }
}
```

Terraform automatically generates all required ingress rules.

---

# Project Structure

```text
dynamic-blocks/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── .gitignore
└── README.md
```

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

### Purpose

Configures AWS as the cloud provider.

---

## variables.tf

```hcl
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ports" {

  description = "List of allowed ingress ports"

  type = list(number)

  default = [
    22,
    80,
    443,
    8080
  ]
}
```

### Purpose

Stores the list of ports to be created dynamically.

---

## main.tf

```hcl
resource "aws_security_group" "web_sg" {

  name        = "dynamic-block-demo"
  description = "Security Group created using Dynamic Blocks"

  dynamic "ingress" {

    for_each = var.allowed_ports

    content {

      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name        = "dynamic-block-demo"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

### Purpose

Creates a Security Group and automatically generates ingress rules based on the ports defined in `allowed_ports`.

---

## outputs.tf

```hcl
output "security_group_id" {
  value = aws_security_group.web_sg.id
}

output "allowed_ports" {
  value = var.allowed_ports
}
```

### Purpose

Displays Security Group details after deployment.

---

# How Dynamic Blocks Work

Terraform reads:

```hcl
allowed_ports = [
  22,
  80,
  443,
  8080
]
```

Then loops through each port.

---

# Generated Configuration

Terraform automatically creates:

```hcl
ingress {
  from_port = 22
  to_port   = 22
}

ingress {
  from_port = 80
  to_port   = 80
}

ingress {
  from_port = 443
  to_port   = 443
}

ingress {
  from_port = 8080
  to_port   = 8080
}
```

No manual repetition is required.

---

# Practical Demonstration

## Step 1 - Initialize Terraform

```bash
terraform init
```

---

## Step 2 - Validate Configuration

```bash
terraform validate
```

Expected Output:

```text
Success! The configuration is valid.
```

---

## Step 3 - Review Execution Plan

```bash
terraform plan
```

Terraform will generate ingress rules for:

```text
22
80
443
8080
```

---

## Step 4 - Deploy Infrastructure

```bash
terraform apply --auto-approve
```

Expected Output:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

## Step 5 - Verify Outputs

```bash
terraform output
```

Example:

```text
allowed_ports = [
  22,
  80,
  443,
  8080
]

security_group_id = "sg-xxxxxxxxxxxx"
```

---

# Adding New Ports

Current Configuration:

```hcl
default = [
  22,
  80,
  443,
  8080
]
```

Add:

```hcl
3306
```

Updated Configuration:

```hcl
default = [
  22,
  80,
  443,
  8080,
  3306
]
```

Run:

```bash
terraform apply
```

Terraform automatically creates:

```text
Port 3306 (MySQL)
```

without modifying the resource block.

---

# Internal Workflow

```text
Allowed Ports
      │
      ▼

[22,80,443,8080]

      │
      ▼

Dynamic Block Loop

      │
      ▼

Generate Ingress Rules

      │
      ▼

Create Security Group
```

---

# Real-World Use Cases

## Security Group Rules

Generate multiple firewall rules dynamically.

---

## IAM Policy Statements

Generate multiple policy statements.

---

## Route Table Routes

Generate multiple routes.

---

## Load Balancer Listeners

Generate multiple listeners.

---

## EBS Volumes

Attach multiple storage volumes dynamically.

---

# Benefits

✅ Eliminates repetitive code

✅ Easy to maintain

✅ Easy to scale

✅ Supports Infrastructure as Code best practices

✅ Improves reusability

---

# When to Use

* Security Group Rules
* IAM Policies
* Route Tables
* Load Balancers
* EBS Volumes
* Any repeating nested block

---

# When NOT to Use

❌ Single static block

❌ Very simple configurations

❌ Top-level resources (use `count` or `for_each` instead)

---

# Interview Question

### What are Dynamic Blocks in Terraform?

Dynamic Blocks allow Terraform to generate multiple nested blocks automatically from a collection such as a list or map. They reduce repetitive code and make Terraform configurations more reusable and maintainable.

Example:

```hcl
dynamic "ingress" {

  for_each = var.allowed_ports

  content {

    from_port = ingress.value
    to_port   = ingress.value

  }
}
```

---

# Key Takeaways

* Dynamic Blocks generate nested blocks automatically.
* Use `for_each` to iterate through collections.
* Commonly used for Security Groups, IAM Policies, and Route Tables.
* Reduce code duplication.
* Improve Terraform maintainability.

---

# Skills Demonstrated

* Terraform Dynamic Blocks
* AWS Security Groups
* Terraform Expressions
* Infrastructure as Code (IaC)
* Cloud Security
* Terraform Best Practices
* Infrastructure Automation
