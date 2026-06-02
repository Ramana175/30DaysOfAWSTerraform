# Day 10 - Terraform Expressions: Conditional Expressions

## Overview

This project demonstrates Terraform **Conditional Expressions**, one of the most commonly used expression types in real-world Infrastructure as Code (IaC) projects.

Conditional expressions allow Terraform to evaluate a condition and return different values based on whether the condition is true or false.

This helps create reusable configurations for multiple environments such as Development, Testing, and Production without duplicating code.

---

# Learning Objectives

By completing this project, you will learn:

* What Conditional Expressions are
* How Terraform evaluates conditions
* How to create environment-specific configurations
* How to optimize infrastructure costs
* Best practices for using conditional logic

---

# What is a Conditional Expression?

A conditional expression evaluates a condition and returns one of two values.

### Syntax

```hcl
condition ? true_value : false_value
```

### How it Works

```text
Condition True?
      │
   ┌──┴──┐
   │     │
  Yes    No
   │     │
   ▼     ▼
true   false
value  value
```

---

# Why Use Conditional Expressions?

Without Conditional Expressions:

```text
Development Configuration
Production Configuration
Testing Configuration
```

Separate files and duplicated code.

With Conditional Expressions:

```text
Single Terraform Configuration
          │
          ▼
Environment-Based Decisions
```

More reusable and easier to maintain.

---

# Project Structure

```text
conditional-expression/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
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

Configures Terraform to use AWS as the cloud provider.

---

## variables.tf

```hcl
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "dev"
}
```

### Purpose

Allows environment-specific deployments.

---

## main.tf

```hcl
resource "aws_instance" "web_server" {

  ami = "ami-091138d0f0d41ff90"

  instance_type = var.environment == "prod" ? "t3.medium" : "t3.micro"

  tags = {
    Name        = "conditional-expression-demo"
    Environment = var.environment
  }
}
```

### Purpose

Creates different EC2 instance types depending on the environment.

---

## outputs.tf

```hcl
output "instance_id" {
  value = aws_instance.web_server.id
}

output "environment" {
  value = var.environment
}

output "instance_type" {
  value = aws_instance.web_server.instance_type
}
```

### Purpose

Displays the deployed environment and selected instance type.

---

# How Terraform Evaluates the Expression

Terraform evaluates:

```hcl
var.environment == "prod" ? "t3.medium" : "t3.micro"
```

---

## Scenario 1: Development Environment

Configuration:

```hcl
environment = "dev"
```

Terraform evaluates:

```hcl
"dev" == "prod" ? "t3.medium" : "t3.micro"
```

Result:

```text
false
```

Selected Instance Type:

```text
t3.micro
```

---

## Scenario 2: Production Environment

Configuration:

```hcl
environment = "prod"
```

Terraform evaluates:

```hcl
"prod" == "prod" ? "t3.medium" : "t3.micro"
```

Result:

```text
true
```

Selected Instance Type:

```text
t3.medium
```

---

# Practical Demonstration

## Step 1: Initialize Terraform

```bash
terraform init
```

---

## Step 2: Validate Configuration

```bash
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

---

## Step 3: Deploy Development Environment

Current value:

```hcl
environment = "dev"
```

Run:

```bash
terraform apply --auto-approve
```

Expected Output:

```text
environment = "dev"
instance_type = "t3.micro"
```

---

## Step 4: Deploy Production Environment

Change:

```hcl
environment = "prod"
```

Run:

```bash
terraform apply --auto-approve
```

Expected Output:

```text
environment = "prod"
instance_type = "t3.medium"
```

---

# Internal Workflow

```text
Environment = prod ?

        │
    ┌───┴───┐
    │       │
   Yes      No
    │       │
    ▼       ▼

t3.medium  t3.micro
```

---

# Real-World Use Cases

## Environment-Based Instance Types

```hcl
instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"
```

Purpose:

Use larger instances in Production and smaller instances in Development.

---

## Enable Monitoring

```hcl
monitoring = var.environment == "prod" ? true : false
```

Purpose:

Enable CloudWatch detailed monitoring only in Production.

---

## Environment-Based Tags

```hcl
tags = {
  Backup = var.environment == "prod" ? "Enabled" : "Disabled"
}
```

Purpose:

Enable backups only for Production resources.

---

## Resource Count

```hcl
count = var.environment == "prod" ? 3 : 1
```

Purpose:

Deploy multiple servers in Production and a single server in Development.

---

## Region-Based Configuration

```hcl
instance_type = var.aws_region == "us-east-1" ? "t3.medium" : "t3.micro"
```

Purpose:

Customize resources based on AWS region.

---

# Benefits

✅ Reduces code duplication

✅ Single configuration for multiple environments

✅ Easy to maintain

✅ Supports cost optimization

✅ Improves configuration flexibility

---

# When to Use

* Environment-specific configurations
* Feature flags
* Cost optimization
* Resource sizing
* Monitoring settings
* Region-specific deployments

---

# When NOT to Use

❌ Complex business logic

❌ Multiple nested conditions

❌ Large decision trees

For complex logic, use:

```hcl
locals {
  instance_type = (
    var.environment == "prod" ? "t3.large" :
    var.environment == "stage" ? "t3.medium" :
    "t3.micro"
  )
}
```

---

# Interview Question

### What is a Conditional Expression in Terraform?

A Conditional Expression allows Terraform to evaluate a condition and return one of two values.

Syntax:

```hcl
condition ? true_value : false_value
```

It is commonly used for environment-specific configurations, feature flags, resource sizing, and cost optimization.

---

# Key Takeaways

* Conditional Expressions evaluate conditions dynamically.
* Return one value when true and another when false.
* Help create reusable Terraform configurations.
* Commonly used in production-grade Infrastructure as Code projects.
* Reduce duplication and improve maintainability.

---

# Skills Demonstrated

* Terraform Expressions
* Conditional Logic
* AWS EC2
* Infrastructure as Code (IaC)
* Environment Management
* Cost Optimization
* Terraform Best Practices
* Cloud Infrastructure Automation
