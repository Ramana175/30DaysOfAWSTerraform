# Assignment 01 - Project Naming Using Terraform Functions

## Overview

In real-world cloud environments, resource naming standards are critical for maintaining consistency, governance, and operational efficiency.

Different engineers may use different naming formats when creating resources, which can lead to inconsistent naming conventions across AWS accounts.

This assignment demonstrates how Terraform String Functions can automatically standardize project names using `lower()` and `replace()`.

---

# Learning Objectives

By completing this assignment, you will learn:

* How to use Terraform String Functions
* How to standardize resource naming conventions
* How to transform user input dynamically
* How to improve infrastructure consistency
* Real-world use cases for Terraform functions

---

# Real-World Problem

Imagine multiple engineers creating AWS resources for the same project.

Examples:

```text
Project ALPHA Resource
PROJECT_ALPHA_RESOURCE
project alpha resource
Project-Alpha-Resource
```

Although they represent the same project, the naming conventions are inconsistent.

This creates challenges in:

* Resource management
* Automation
* Compliance
* Cost tracking
* Governance

Organizations typically enforce standardized naming conventions to solve this problem.

---

# Solution

Terraform provides built-in String Functions that can automatically transform names into a consistent format.

Functions Used:

* `lower()`
* `replace()`

Input:

```text
Project ALPHA Resource
```

Terraform Expression:

```hcl
lower(
  replace(
    var.project_name,
    " ",
    "-"
  )
)
```

Output:

```text
project-alpha-resource
```

---

# Project Structure

```text
Assignment01-Project-Naming/
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

Configures Terraform and the AWS Provider.

```hcl
provider "aws" {
  region = var.aws_region
}
```

---

## variables.tf

Defines the input project name.

```hcl
variable "project_name" {
  default = "Project ALPHA Resource"
}
```

---

## main.tf

Transforms the project name into a standardized format.

```hcl
locals {

  standardized_project_name = lower(
    replace(
      var.project_name,
      " ",
      "-"
    )
  )
}
```

---

## outputs.tf

Displays the original and transformed project names.

```hcl
output "standardized_project_name" {
  value = local.standardized_project_name
}
```

---

# How It Works

Step 1: Input Value

```text
Project ALPHA Resource
```

Step 2: Replace Spaces

```text
Project-ALPHA-Resource
```

Step 3: Convert to Lowercase

```text
project-alpha-resource
```

Final Result:

```text
project-alpha-resource
```

---

# Practical Demonstration

## Initialize Terraform

```bash
terraform init
```

---

## Validate Configuration

```bash
terraform validate
```

Expected Output:

```text
Success! The configuration is valid.
```

---

## Apply Configuration

```bash
terraform apply --auto-approve
```

---

## View Outputs

Example:

```text
original_project_name = "Project ALPHA Resource"

standardized_project_name = "project-alpha-resource"
```

---

# Real-World Use Cases

This pattern is commonly used for:

### S3 Bucket Naming

```text
project-alpha-resource-logs
```

### IAM Role Naming

```text
project-alpha-resource-admin-role
```

### Resource Tags

```text
Project = project-alpha-resource
```

### Kubernetes Resources

```text
project-alpha-resource-deployment
```

---

# Benefits

✅ Consistent naming conventions

✅ Reduced human error

✅ Improved automation

✅ Easier resource management

✅ Better governance and compliance

---

# Interview Question

### Why use Terraform functions for resource naming?

Terraform functions help automate naming standards and eliminate manual inconsistencies. They ensure resources follow organizational naming conventions, making infrastructure easier to manage and maintain.

---

# Key Takeaways

* `replace()` substitutes characters within a string.
* `lower()` converts text to lowercase.
* Combining functions creates standardized resource names.
* Standardized naming improves cloud governance.
* Terraform functions reduce manual effort and improve consistency.

---

# Skills Demonstrated

* Terraform Functions
* String Manipulation
* Infrastructure as Code (IaC)
* Cloud Governance
* AWS Best Practices
* Automation
* DevOps Fundamentals

---

### Assignment Status

✅ Completed

### Functions Covered

* lower()
* replace()

### Difficulty

⭐ Beginner

Part of the **#30DaysOfAWSTerraform** challenge.
