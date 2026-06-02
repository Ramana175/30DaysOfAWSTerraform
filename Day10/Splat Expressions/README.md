# Day 10 - Terraform Expressions: Splat Expressions

## Overview

This project demonstrates Terraform **Splat Expressions**.

A Splat Expression uses the `[*]` operator to extract a specific attribute from every element in a collection.

Instead of writing loops manually, Terraform can retrieve values from multiple resources in a single expression.

---

# Learning Objectives

By completing this project, you will learn:

* What Splat Expressions are
* How the `[*]` operator works
* How to extract attributes from multiple resources
* How to simplify Terraform outputs
* Real-world use cases for Splat Expressions

---

# What is a Splat Expression?

A Splat Expression extracts an attribute from every object in a list.

Syntax:

```hcl
resource_name[*].attribute
```

Example:

```hcl
aws_instance.web_server[*].id
```

Terraform returns:

```text
[
  "i-123456",
  "i-789012",
  "i-345678"
]
```

---

# Why Use Splat Expressions?

Without Splat Expressions:

```hcl
aws_instance.web_server[0].id
aws_instance.web_server[1].id
aws_instance.web_server[2].id
```

With Splat Expressions:

```hcl
aws_instance.web_server[*].id
```

Cleaner and easier to maintain.

---

# Project Structure

```text
splat-expressions/
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

## variables.tf

```hcl
variable "instance_count" {
  default = 3
}
```

Terraform creates:

```text
3 EC2 Instances
```

---

## main.tf

```hcl
resource "aws_instance" "web_server" {

  count = var.instance_count

  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t3.micro"

  tags = {
    Name = "web-server-${count.index + 1}"
  }
}
```

---

## outputs.tf

```hcl
output "instance_ids" {
  value = aws_instance.web_server[*].id
}

output "public_ips" {
  value = aws_instance.web_server[*].public_ip
}

output "private_ips" {
  value = aws_instance.web_server[*].private_ip
}
```

---

# How It Works

Terraform creates:

```text
web-server-1
web-server-2
web-server-3
```

Each instance has:

```text
ID
Public IP
Private IP
```

The splat operator:

```hcl
aws_instance.web_server[*].id
```

collects all instance IDs into a single list.

---

# Practical Demonstration

## Step 1 - Initialize

```bash
terraform init
```

---

## Step 2 - Validate

```bash
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

---

## Step 3 - Plan

```bash
terraform plan
```

Expected:

```text
Plan: 3 to add, 0 to change, 0 to destroy
```

---

## Step 4 - Apply

```bash
terraform apply --auto-approve
```

Expected:

```text
Apply complete! Resources: 3 added.
```

---

## Step 5 - Verify Outputs

```bash
terraform output
```

Example:

```text
instance_ids = [
  "i-0123456789",
  "i-0987654321",
  "i-1122334455"
]

public_ips = [
  "54.210.10.1",
  "54.210.10.2",
  "54.210.10.3"
]

private_ips = [
  "172.31.10.1",
  "172.31.10.2",
  "172.31.10.3"
]
```

---

# Internal Workflow

```text
EC2 Instances
      │
      ▼

[Instance1, Instance2, Instance3]

      │
      ▼

Splat Expression

      │
      ▼

aws_instance.web_server[*].id

      │
      ▼

[ID1, ID2, ID3]
```

---

# Common Examples

## Get All Instance IDs

```hcl
aws_instance.web_server[*].id
```

---

## Get All Public IPs

```hcl
aws_instance.web_server[*].public_ip
```

---

## Get All Private IPs

```hcl
aws_instance.web_server[*].private_ip
```

---

## Get All ARNs

```hcl
aws_instance.web_server[*].arn
```

---

## Get All Bucket Names

```hcl
aws_s3_bucket.bucket[*].bucket
```

---

# Benefits

✅ Short and readable syntax

✅ Eliminates repetitive code

✅ Easy to collect resource attributes

✅ Works well with count

✅ Simplifies outputs

---

# When to Use

* Multiple EC2 Instances
* Multiple S3 Buckets
* Multiple Security Groups
* Multiple Subnets
* Multiple IAM Roles
* Resource Outputs

---

# Interview Question

### What is a Splat Expression in Terraform?

A Splat Expression uses the `[*]` operator to extract a specific attribute from every element in a collection. It returns a list containing those values and simplifies working with multiple resources created using `count`.

Example:

```hcl
aws_instance.web_server[*].id
```

This returns the IDs of all EC2 instances in a single list.

---

# Key Takeaways

* Splat Expressions use the `[*]` operator.
* Extract attributes from all elements in a collection.
* Reduce repetitive code.
* Commonly used with resources created using `count`.
* Simplify outputs and resource references.

---

# Skills Demonstrated

* Terraform Expressions
* Splat Operator
* AWS EC2
* Terraform Count
* Infrastructure as Code (IaC)
* Cloud Automation
* Terraform Best Practices
