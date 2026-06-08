# Assignment 08 - File Path Processing Using Terraform Functions

## Overview

In modern Infrastructure as Code (IaC) environments, Terraform frequently works with external configuration files such as JSON, YAML, Terraform variable files, and application settings.

Before using these files, it is important to verify that they exist and determine their location within the project structure.

This assignment demonstrates how to use Terraform's built-in file functions:

* `fileexists()`
* `dirname()`

to safely process file paths and improve deployment reliability.

---

# Learning Objectives

By completing this assignment, you will learn:

* How to verify file existence using `fileexists()`
* How to extract directory paths using `dirname()`
* How Terraform handles file-based operations
* Best practices for configuration management
* Real-world use cases for file validation

---

# Real-World Problem

Imagine a Terraform deployment that depends on a configuration file:

```text
configs/dev/config.json
```

If the file is accidentally deleted or moved:

```text
Terraform Apply
      │
      ▼
File Missing
      │
      ▼
Deployment Failure
```

This can cause:

❌ Application deployment failures

❌ Broken CI/CD pipelines

❌ Configuration errors

❌ Troubleshooting delays

---

# Solution

Terraform provides functions that help validate and process file paths before deployment.

Functions Used:

* `fileexists()`
* `dirname()`

---

# Functions Explained

## fileexists()

Checks whether a file exists.

### Syntax

```hcl
fileexists("config.json")
```

### Output

```text
true
```

If the file does not exist:

```text
false
```

---

## dirname()

Extracts the directory portion of a file path.

### Syntax

```hcl
dirname("configs/dev/config.json")
```

### Output

```text
configs/dev
```

---

# Project Structure

```text
Assignment08-File-Path-Processing/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── config.json
└── README.md
```

---

# Terraform Files

## provider.tf

Configures the AWS Provider.

```hcl
provider "aws" {
  region = var.aws_region
}
```

---

## variables.tf

Stores the configuration file path.

```hcl
variable "config_file_path" {

  description = "Configuration file path"

  type = string

  default = "config.json"
}
```

---

## main.tf

Processes file paths using Terraform functions.

```hcl
locals {

  config_file_exists = fileexists(
    var.config_file_path
  )

  config_directory = dirname(
    "configs/dev/config.json"
  )
}
```

---

## outputs.tf

Displays results.

```hcl
output "config_file_exists" {

  value = local.config_file_exists
}

output "config_directory" {

  value = local.config_directory
}
```

---

# How It Works

Input File:

```text
configs/dev/config.json
```

Terraform:

```text
dirname()
```

Result:

```text
configs/dev
```

---

Terraform:

```text
fileexists("config.json")
```

Result:

```text
true
```

---

# Internal Workflow

```text
Configuration File
        │
        ▼

config.json

        │
        ▼

fileexists()

        │
        ▼

true

--------------------------------

configs/dev/config.json

        │
        ▼

dirname()

        │
        ▼

configs/dev
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

Expected Output:

```text
Success! The configuration is valid.
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
config_file_exists = true

config_directory = "configs/dev"
```

---

# Real-World Use Cases

### Configuration Management

Validate JSON and YAML configuration files before deployment.

### Terraform Modules

Ensure required files exist before module execution.

### CI/CD Pipelines

Prevent deployment failures caused by missing files.

### Infrastructure Automation

Automatically process file locations.

### Application Deployments

Manage application configuration paths dynamically.

---

# Benefits

✅ Prevents deployment failures

✅ Improves reliability

✅ Simplifies troubleshooting

✅ Validates configuration files

✅ Enhances automation workflows

---

# Interview Question

### What is the purpose of fileexists() in Terraform?

The `fileexists()` function checks whether a specified file exists and returns either `true` or `false`.

Example:

```hcl
fileexists("config.json")
```

Output:

```text
true
```

---

### What is dirname() used for?

The `dirname()` function extracts the directory portion of a file path.

Example:

```hcl
dirname("configs/dev/config.json")
```

Output:

```text
configs/dev
```

---

# Key Takeaways

* `fileexists()` validates file presence.
* `dirname()` extracts directory paths.
* Useful for configuration management.
* Prevents deployment failures caused by missing files.
* Commonly used in enterprise Terraform projects.

---

# Skills Demonstrated

* Terraform Functions
* fileexists()
* dirname()
* Configuration Management
* Infrastructure as Code (IaC)
* DevOps Automation
* Cloud Infrastructure

---

### Assignment Status

✅ Completed

### Functions Covered

* fileexists()
* dirname()

### Difficulty

⭐⭐ Intermediate

Part of the **#30DaysOfAWSTerraform** challenge.
