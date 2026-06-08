# Assignment 10 - Cost Calculation Using Terraform Functions

## Overview

One of the most important responsibilities of Cloud and DevOps Engineers is monitoring and optimizing infrastructure costs.

Organizations often need to:

* Calculate total monthly cloud spending
* Identify the highest-cost resource
* Analyze cost differences between environments
* Generate cost reports for management

This assignment demonstrates how Terraform Numeric Functions can perform basic cost calculations directly within Terraform.

Functions Covered:

* `sum()`
* `max()`
* `abs()`

---

# Learning Objectives

By completing this assignment, you will learn:

* How to calculate totals using `sum()`
* How to find the largest value using `max()`
* How to calculate absolute differences using `abs()`
* How Terraform handles numeric operations
* Real-world cost management use cases

---

# Real-World Problem

Imagine your cloud team receives monthly spending data:

```text
EC2 Cost      = $120
RDS Cost      = $250
S3 Cost       = $80
CloudFront    = $50
```

Management wants answers to:

* What is the total cost?
* Which service costs the most?
* What is the difference between budget and actual spending?

Without automation, engineers must calculate these manually.

---

# Solution

Terraform Numeric Functions can perform these calculations automatically.

Functions Used:

* `sum()`
* `max()`
* `abs()`

---

# Function Explained

## sum()

Adds all values in a list.

### Example

```hcl
sum([
  120,
  250,
  80,
  50
])
```

### Output

```text
500
```

---

## max()

Returns the highest value.

### Example

```hcl
max(
  120,
  250,
  80,
  50
)
```

### Output

```text
250
```

---

## abs()

Returns the absolute value.

### Example

```hcl
abs(-100)
```

### Output

```text
100
```

---

# Project Structure

```text
Assignment10-Cost-Calculation/
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

Configures Terraform and AWS Provider.

```hcl
provider "aws" {
  region = var.aws_region
}
```

---

## variables.tf

Stores monthly cloud costs.

```hcl
variable "monthly_costs" {

  type = list(number)

  default = [
    120,
    250,
    80,
    50
  ]
}
```

---

## main.tf

Performs cost calculations.

```hcl
# =============================================================================
# Assignment 10: Cost Calculation
# =============================================================================
# Purpose:
# Calculate total cloud spending and identify
# the most expensive service.
#
# Functions Used:
# - sum()
# - max()
# - abs()
# =============================================================================

locals {

  total_cost = sum(
    var.monthly_costs
  )

  highest_cost = max(
    var.monthly_costs...
  )

  budget_difference = abs(
    400 - local.total_cost
  )
}
```

---

## outputs.tf

Displays cost metrics.

```hcl
output "total_cost" {

  value = local.total_cost
}

output "highest_cost" {

  value = local.highest_cost
}

output "budget_difference" {

  value = local.budget_difference
}
```

---

# How It Works

### Input Costs

```text
EC2       = 120
RDS       = 250
S3        = 80
CloudFront= 50
```

---

### Calculate Total Cost

Terraform:

```hcl
sum()
```

Output:

```text
500
```

---

### Find Highest Cost

Terraform:

```hcl
max()
```

Output:

```text
250
```

---

### Compare Against Budget

Budget:

```text
400
```

Actual:

```text
500
```

Terraform:

```hcl
abs()
```

Output:

```text
100
```

---

# Internal Workflow

```text
Monthly Costs
       │
       ▼

sum()
       │
       ▼

Total Cost

-----------------------

Monthly Costs
       │
       ▼

max()
       │
       ▼

Highest Cost

-----------------------

Budget vs Actual
       │
       ▼

abs()
       │
       ▼

Difference
```

---

# Deployment Steps

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Review Execution Plan

```bash
terraform plan
```

## Apply Configuration

```bash
terraform apply --auto-approve
```

## View Outputs

```bash
terraform output
```

---

# Example Output

```text
total_cost = 500

highest_cost = 250

budget_difference = 100
```

---

# Real-World Use Cases

### Cloud Cost Reporting

Generate monthly infrastructure reports.

### Budget Tracking

Compare actual spending against budget.

### Resource Optimization

Identify high-cost services.

### FinOps Practices

Support cloud financial management.

### Capacity Planning

Understand infrastructure spending trends.

---

# Benefits

✅ Automated cost calculations

✅ Better budget visibility

✅ Improved financial planning

✅ Easier reporting

✅ Supports FinOps initiatives

---

# Interview Question

### What does sum() do in Terraform?

The `sum()` function adds all numbers in a list and returns the total.

Example:

```hcl
sum([100, 200, 300])
```

Output:

```text
600
```

---

### Why use abs()?

The `abs()` function returns the absolute value of a number and is useful when calculating differences between expected and actual values.

Example:

```hcl
abs(-50)
```

Output:

```text
50
```

---

# Key Takeaways

* `sum()` calculates totals.
* `max()` identifies the highest value.
* `abs()` calculates absolute differences.
* Useful for cloud cost monitoring.
* Commonly used in reporting and FinOps workflows.

---

# Skills Demonstrated

* Terraform Functions
* sum()
* max()
* abs()
* Cost Management
* FinOps
* Infrastructure as Code
* DevOps Best Practices

---

### Assignment Status

✅ Completed

### Functions Covered

* sum()
* max()
* abs()

### Difficulty

⭐⭐ Intermediate

Part of the **#30DaysOfAWSTerraform** challenge.
