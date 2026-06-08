# Assignment 06 - Instance Validation Using Terraform Functions

## Overview

Infrastructure deployments should fail fast when invalid inputs are provided.

One of the most common causes of Terraform deployment failures is incorrect configuration values.

This assignment demonstrates how Terraform validation functions can verify user input before resources are created.

---

# Learning Objectives

By completing this assignment, you will learn:

* How to use `length()`
* How to use `can()`
* How to use `regex()`
* How to validate Terraform inputs
* How to prevent invalid deployments

---

# Real-World Problem

Imagine an engineer accidentally enters:

```text
instance_type = "abc123"
```

instead of:

```text
instance_type = "t3.micro"
```

Terraform would attempt to create the resource and AWS would reject the request.

This leads to:

❌ Failed deployments

❌ Wasted time

❌ Configuration errors

❌ Operational delays

---

# Solution

Terraform validation functions help detect problems before deployment.

Functions Used:

* `length()`
* `can()`
* `regex()`

---

# Functions Explained

## regex()

Checks whether a string matches a pattern.

Example:

```hcl
regex("^t3\\.", "t3.micro")
```

Output:

```text
t3.
```

---

## can()

Returns true if an expression executes successfully.

Example:

```hcl
can(regex("^t3\\.", "t3.micro"))
```

Output:

```text
true
```

---

## length()

Returns the number of characters in a string.

Example:

```hcl
length("t3.micro")
```

Output:

```text
8
```

---

# Validation Logic

Terraform checks:

```hcl
can(
  regex(
    "^t3\\.",
    var.instance_type
  )
)
```

Valid Examples:

```text
t3.micro
t3.small
t3.medium
```

Invalid Examples:

```text
abc123
test-server
xyz.large
```

---

# How It Works

```text
User Input
      │
      ▼

t3.micro

      │
      ▼

regex()

      │
      ▼

Pattern Match

      │
      ▼

can()

      │
      ▼

true

      │
      ▼

Resource Created
```

---

# Invalid Example

Input:

```text
abc123
```

Terraform:

```text
regex() fails
```

Result:

```text
Error:
Instance type must start with 't3.'
```

---

# Deployment Steps

Initialize:

```bash
terraform init
```

Validate:

```bash
terraform validate
```

Plan:

```bash
terraform plan
```

Apply:

```bash
terraform apply --auto-approve
```

Outputs:

```bash
terraform output
```

---

# Example Output

```text
instance_type = "t3.micro"

instance_type_length = 8

validation_result = true
```

---

# Real-World Use Cases

### EC2 Instance Validation

Ensure approved instance families are used.

### Resource Naming Validation

Verify naming conventions.

### Security Standards

Validate approved configurations.

### Compliance Controls

Prevent unauthorized deployments.

### Infrastructure Policies

Enforce organizational standards.

---

# Benefits

✅ Prevents invalid deployments

✅ Improves reliability

✅ Reduces human error

✅ Enforces standards

✅ Saves troubleshooting time

---

# Interview Question

### Why use can() with regex() in Terraform?

`regex()` throws an error when no match is found. Wrapping it with `can()` converts the result into a simple true/false value, making validation safer and easier to use.

Example:

```hcl
can(regex("^t3\\.", var.instance_type))
```

---

# Key Takeaways

* `regex()` validates patterns.
* `can()` safely handles errors.
* `length()` measures string size.
* Input validation prevents deployment failures.
* Validation improves infrastructure quality.

---

# Skills Demonstrated

* Terraform Functions
* length()
* can()
* regex()
* AWS EC2
* Infrastructure Validation
* DevOps Best Practices

### Assignment Status

✅ Completed

### Functions Covered

* length()
* can()
* regex()

### Difficulty

⭐⭐⭐ Intermediate

Part of the **#30DaysOfAWSTerraform** challenge.
