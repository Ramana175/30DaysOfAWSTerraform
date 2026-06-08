# Assignment 09 - Location Management Using Terraform Functions

## Overview

Modern cloud applications are rarely deployed in a single region.

Organizations often deploy infrastructure across multiple AWS regions for:

* High Availability
* Disaster Recovery
* Global User Access
* Business Continuity

Different teams may provide separate region lists, which can lead to duplicate entries and configuration complexity.

This assignment demonstrates how Terraform Collection Functions can combine multiple region lists and automatically remove duplicate values.

Functions Covered:

* `concat()`
* `toset()`

---

# Learning Objectives

By completing this assignment, you will learn:

* How to combine lists using `concat()`
* How to remove duplicates using `toset()`
* How Terraform handles collections
* How to prepare region lists for deployment
* Real-world multi-region deployment practices

---

# Real-World Problem

Imagine your organization has two cloud teams.

### Team A

Responsible for primary deployments.

```text id="ek3qzj"
us-east-1
us-west-2
```

### Team B

Responsible for disaster recovery regions.

```text id="e9i6bk"
us-west-2
eu-west-1
ap-south-1
```

Notice:

```text id="k6b2me"
us-west-2
```

appears in both lists.

Without processing:

❌ Duplicate deployments

❌ Configuration drift

❌ Increased maintenance

❌ Complex infrastructure management

---

# Solution

Terraform Collection Functions can combine and clean region data automatically.

Functions Used:

* `concat()`
* `toset()`

---

# Function Explained

## concat()

Combines multiple lists into a single list.

### Example

```hcl id="57ibf3"
concat(
  ["us-east-1"],
  ["eu-west-1"]
)
```

### Output

```text id="gztxdk"
[
  "us-east-1",
  "eu-west-1"
]
```

---

## toset()

Converts a list into a set.

Sets automatically remove duplicate values.

### Example

```hcl id="k2i7zt"
toset([
  "us-east-1",
  "us-east-1",
  "eu-west-1"
])
```

### Output

```text id="1rbl90"
[
  "us-east-1",
  "eu-west-1"
]
```

---

# Project Structure

```text id="m22g2w"
Assignment09-Location-Management/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── README.md
```

---

# Terraform Files

## provider.tf

Configures the AWS Provider.

```hcl id="vkpk9j"
provider "aws" {
  region = var.aws_region
}
```

---

## variables.tf

Stores region information.

```hcl id="6p4q6x"
variable "primary_regions" {

  default = [
    "us-east-1",
    "us-west-2"
  ]
}

variable "secondary_regions" {

  default = [
    "us-west-2",
    "eu-west-1",
    "ap-south-1"
  ]
}
```

---

## main.tf

Combines and cleans region data.

```hcl id="9gs5mb"
locals {

  all_regions = concat(
    var.primary_regions,
    var.secondary_regions
  )

  unique_regions = toset(
    local.all_regions
  )
}
```

---

## outputs.tf

Displays processed regions.

```hcl id="0z0n7m"
output "unique_regions" {

  value = local.unique_regions
}
```

---

# How It Works

### Step 1: Input Region Lists

```text id="djlwmf"
Primary Regions

us-east-1
us-west-2

Secondary Regions

us-west-2
eu-west-1
ap-south-1
```

---

### Step 2: Combine Lists

Terraform:

```hcl id="k4r7wj"
concat()
```

Output:

```text id="f4flq7"
[
  "us-east-1",
  "us-west-2",
  "us-west-2",
  "eu-west-1",
  "ap-south-1"
]
```

---

### Step 3: Remove Duplicates

Terraform:

```hcl id="cfkjn0"
toset()
```

Output:

```text id="hpdwku"
[
  "us-east-1",
  "us-west-2",
  "eu-west-1",
  "ap-south-1"
]
```

---

# Internal Workflow

```text id="diy6vf"
Primary Regions
        │
        ▼

Secondary Regions
        │
        ▼

concat()
        │
        ▼

Combined Region List
        │
        ▼

toset()
        │
        ▼

Unique Region List
```

---

# Deployment Steps

## Initialize Terraform

```bash id="w1jkvo"
terraform init
```

---

## Validate Configuration

```bash id="x6z6kg"
terraform validate
```

---

## Review Execution Plan

```bash id="sqcz9q"
terraform plan
```

---

## Apply Configuration

```bash id="3mjvwm"
terraform apply --auto-approve
```

---

## View Outputs

```bash id="vfql5q"
terraform output
```

---

# Example Output

```text id="73yxnl"
combined_regions = [
  "us-east-1",
  "us-west-2",
  "us-west-2",
  "eu-west-1",
  "ap-south-1"
]

unique_regions = [
  "us-east-1",
  "us-west-2",
  "eu-west-1",
  "ap-south-1"
]
```

---

# Real-World Use Cases

### Multi-Region Deployments

Deploy workloads across multiple AWS regions.

### Disaster Recovery

Maintain backup infrastructure in alternate locations.

### Global Applications

Serve users from geographically distributed regions.

### Cloud Migration

Merge region inventories from multiple teams.

### Infrastructure Standardization

Maintain a clean and unique deployment region list.

---

# Benefits

✅ Eliminates duplicate values

✅ Simplifies region management

✅ Improves automation

✅ Supports multi-region architectures

✅ Reduces configuration errors

---

# Interview Question

### What is the difference between concat() and toset()?

**concat()**

Combines multiple lists into a single list.

Example:

```hcl id="8i36q7"
concat(list1, list2)
```

---

**toset()**

Converts a list into a set and automatically removes duplicate values.

Example:

```hcl id="3bnjdi"
toset(list)
```

---

### Why use concat() and toset() together?

A common pattern in Terraform is:

```hcl id="i71p9m"
toset(
  concat(
    list1,
    list2
  )
)
```

This combines multiple lists and removes duplicate entries before deployment.

---

# Key Takeaways

* `concat()` combines lists.
* `toset()` removes duplicate values.
* Useful for multi-region deployments.
* Improves infrastructure consistency.
* Commonly used in enterprise Terraform projects.

---

# Skills Demonstrated

* Terraform Functions
* concat()
* toset()
* Collection Handling
* AWS Multi-Region Architecture
* Infrastructure as Code (IaC)
* DevOps Best Practices

---

### Assignment Status

✅ Completed

### Functions Covered

* concat()
* toset()

### Difficulty

⭐ Beginner

Part of the **#30DaysOfAWSTerraform** challenge.
