# Assignment 05 - Environment Lookup Using Terraform lookup()

## Overview

In real-world cloud environments, different deployment environments require different infrastructure configurations.

For example:

* Development environments use smaller instances to reduce costs.
* Testing environments require moderate resources.
* Production environments need larger instances for performance and availability.

This assignment demonstrates how Terraform's `lookup()` function can dynamically select configuration values based on the deployment environment.

---

# Learning Objectives

By completing this assignment, you will learn:

* How to use the `lookup()` function
* How to manage environment-specific configurations
* How to reduce code duplication
* How to build reusable Terraform configurations
* Best practices for multi-environment deployments

---

# Real-World Problem

Imagine an organization running three environments:

```text
Development
Testing
Production
```

Each environment requires a different EC2 instance size.

Without automation:

```text
Dev  -> t3.micro
Test -> t3.small
Prod -> t3.medium
```

Engineers would manually change instance types before every deployment.

This creates:

❌ Human errors

❌ Configuration drift

❌ Duplicate code

❌ Difficult maintenance

---

# Solution

Terraform's `lookup()` function retrieves values from a map based on a key.

Example:

```hcl
lookup(
  local.instance_types,
  var.environment,
  "t3.micro"
)
```

Terraform automatically selects the correct instance type.

---

# Function Used

## lookup()

Retrieves a value from a map using a key.

Syntax:

```hcl
lookup(
  map,
  key,
  default_value
)
```

Example:

```hcl
lookup(
  {
    dev  = "t3.micro"
    prod = "t3.medium"
  },
  "prod",
  "t3.micro"
)
```

Output:

```text
t3.medium
```

---

# Environment Mapping

```hcl
{
  dev  = "t3.micro"
  test = "t3.small"
  prod = "t3.medium"
}
```

Terraform automatically selects the correct value based on:

```hcl
var.environment
```

---

# How It Works

### Environment = dev

```text
lookup()
      │
      ▼

dev
      │
      ▼

t3.micro
```

---

### Environment = test

```text
lookup()
      │
      ▼

test
      │
      ▼

t3.small
```

---

### Environment = prod

```text
lookup()
      │
      ▼

prod
      │
      ▼

t3.medium
```

---

# Deployment Steps

Initialize Terraform:

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

Deploy:

```bash
terraform apply --auto-approve
```

View Outputs:

```bash
terraform output
```

---

# Example Outputs

### Development

```text
environment = dev

instance_type = t3.micro
```

---

### Testing

```text
environment = test

instance_type = t3.small
```

---

### Production

```text
environment = prod

instance_type = t3.medium
```

---

# Real-World Use Cases

### EC2 Instance Selection

Choose instance sizes dynamically.

### RDS Database Sizing

Different environments require different database classes.

### Auto Scaling

Adjust capacity based on environment.

### Kubernetes Clusters

Provision different node sizes.

### Cost Optimization

Use smaller resources in non-production environments.

---

# Benefits

✅ Reduces code duplication

✅ Supports multiple environments

✅ Improves maintainability

✅ Minimizes deployment errors

✅ Enables reusable Terraform code

---

# Interview Question

### What is the purpose of the lookup() function in Terraform?

The `lookup()` function retrieves a value from a map using a specified key. If the key does not exist, Terraform returns a default value.

Example:

```hcl
lookup(
  local.instance_types,
  var.environment,
  "t3.micro"
)
```

This allows Terraform configurations to adapt dynamically based on deployment environments.

---

# Key Takeaways

* lookup() retrieves values from maps.
* Useful for environment-specific configurations.
* Reduces hardcoded values.
* Improves code reusability.
* Commonly used in production Terraform projects.

---

# Skills Demonstrated

* Terraform Functions
* lookup()
* AWS EC2
* Infrastructure as Code (IaC)
* Environment Management
* Cloud Automation
* DevOps Best Practices

### Assignment Status

✅ Completed

### Function Covered

* lookup()

### Difficulty

⭐⭐ Intermediate

Part of the **#30DaysOfAWSTerraform** challenge.
