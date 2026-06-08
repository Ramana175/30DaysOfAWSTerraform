# Assignment 02 - Resource Tagging Using Terraform merge()

## Overview

Resource tagging is one of the most important practices in cloud environments.

Organizations use tags to identify resources, track costs, automate operations, and maintain compliance.

This assignment demonstrates how Terraform's `merge()` function combines multiple tag maps into a single reusable tag structure.

---

# Learning Objectives

By completing this assignment, you will learn:

* How to use the `merge()` function
* How to standardize AWS resource tagging
* How to reduce duplicate code
* How organizations use tags for governance
* Best practices for Infrastructure as Code

---

# Real-World Problem

Imagine your organization requires every AWS resource to have:

```text
Environment
Team
ManagedBy
Project
Owner
```

Without Terraform functions, you would manually add these tags to every resource.

This creates:

❌ Repetitive code

❌ Maintenance challenges

❌ Inconsistent tagging

❌ Human errors

---

# Solution

Terraform's `merge()` function combines multiple maps into one.

Example:

```hcl
merge(
  local.common_tags,
  local.project_tags
)
```

Terraform automatically generates:

```text
Environment = dev
ManagedBy   = Terraform
Team        = DevOps
Project     = Terraform Functions
Owner       = Ramana
```

---

# Project Structure

```text
Assignment02-Resource-Tagging/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── README.md
```

---

# Functions Used

## merge()

Combines multiple maps into a single map.

Example:

```hcl
merge(
  map1,
  map2
)
```

Output:

```text
Single Combined Map
```

---

# Practical Example

### Common Tags

```hcl
{
  Environment = "dev"
  Team        = "DevOps"
}
```

### Project Tags

```hcl
{
  Project = "Terraform Functions"
  Owner   = "Ramana"
}
```

### Final Result

```hcl
{
  Environment = "dev"
  Team        = "DevOps"
  Project     = "Terraform Functions"
  Owner       = "Ramana"
}
```

---

# How It Works

```text
Common Tags
      │
      ▼

Project Tags
      │
      ▼

merge()
      │
      ▼

Combined Tags
      │
      ▼

Apply to AWS Resource
```

---

# Deployment Steps

## Initialize Terraform

```bash
terraform init
```

---

## Validate Configuration

```bash
terraform validate
```

---

## Review Plan

```bash
terraform plan
```

---

## Deploy Infrastructure

```bash
terraform apply --auto-approve
```

---

## View Outputs

```bash
terraform output
```

Example:

```text
merged_tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  Owner       = "Ramana"
  Project     = "Terraform Functions"
  Team        = "DevOps"
}
```

---

# Real-World Use Cases

### Cost Allocation

Track AWS spending by project.

### Resource Ownership

Identify responsible teams.

### Governance

Enforce organizational standards.

### Compliance

Meet audit requirements.

### Automation

Use tags to trigger automated workflows.

---

# Benefits

✅ Consistent tagging

✅ Reduced code duplication

✅ Easier maintenance

✅ Better governance

✅ Improved visibility

---

# Interview Question

### What does the merge() function do in Terraform?

The `merge()` function combines two or more maps into a single map. It is commonly used for resource tagging, configuration management, and reusable Infrastructure as Code patterns.

Example:

```hcl
merge(
  local.common_tags,
  local.project_tags
)
```

---

# Key Takeaways

* `merge()` combines multiple maps.
* Useful for AWS resource tagging.
* Reduces repetitive code.
* Improves infrastructure consistency.
* Commonly used in production Terraform projects.

---

# Skills Demonstrated

* Terraform Functions
* merge()
* AWS VPC
* Resource Tagging
* Infrastructure as Code (IaC)
* Cloud Governance
* DevOps Best Practices

---

### Assignment Status

✅ Completed

### Function Covered

* merge()

### Difficulty

⭐ Beginner

Part of the **#30DaysOfAWSTerraform** challenge.
