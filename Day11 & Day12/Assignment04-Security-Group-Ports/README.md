# Assignment 04 - Security Group Ports Using Terraform Functions

## Overview

Managing network ports is a common task in cloud infrastructure.

Network teams often provide ports in a simple comma-separated format:

```text
22,80,443,8080
```

However, Terraform requires structured data to create Security Group rules.

This assignment demonstrates how Terraform functions can transform raw input into a format that can be used for infrastructure provisioning.

---

# Learning Objectives

By completing this assignment, you will learn:

* How to use split()
* How to use join()
* How to use for expressions
* How to create dynamic Security Group rules
* How to transform user input into infrastructure configuration

---

# Real-World Problem

Imagine a network engineer sends:

```text
22,80,443,8080
```

Terraform cannot directly use this string to create Security Group rules.

We need to:

1. Split the string into individual ports
2. Convert ports into numbers
3. Create Security Group rules dynamically

---

# Functions Used

## split()

Converts a string into a list.

Example:

```hcl
split(",", "22,80,443")
```

Output:

```text
["22","80","443"]
```

---

## join()

Combines list values into a string.

Example:

```hcl
join("-", ["22","80","443"])
```

Output:

```text
22-80-443
```

---

## for Expression

Transforms collection values.

Example:

```hcl
[
  for port in local.port_list :
  tonumber(port)
]
```

Output:

```text
[22,80,443]
```

---

# How It Works

Input:

```text
22,80,443,8080
```

Terraform:

```text
split()
```

Result:

```text
["22","80","443","8080"]
```

Terraform:

```text
for expression
```

Result:

```text
[22,80,443,8080]
```

Terraform:

```text
dynamic ingress rules
```

Result:

```text
SSH   -> 22
HTTP  -> 80
HTTPS -> 443
APP   -> 8080
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
original_ports = "22,80,443,8080"

port_list = [
  "22",
  "80",
  "443",
  "8080"
]

joined_ports = "22-80-443-8080"
```

---

# Real-World Use Cases

### Security Groups

Generate ingress rules dynamically.

### Firewall Policies

Process network ports automatically.

### Kubernetes Services

Manage service ports.

### Application Deployments

Configure web and application ports.

---

# Benefits

✅ Reduces manual configuration

✅ Easy to add new ports

✅ Supports dynamic infrastructure

✅ Improves automation

✅ Makes configurations reusable

---

# Interview Question

### Why use split() in Terraform?

The split() function converts a string into a list. It is commonly used when user input or configuration values are provided as comma-separated strings.

Example:

```hcl
split(",", "22,80,443")
```

Output:

```text
["22","80","443"]
```

---

# Key Takeaways

* split() converts strings into lists.
* join() converts lists into strings.
* for expressions transform collection values.
* Dynamic infrastructure becomes easier to manage.
* Commonly used for networking configurations.

---

# Skills Demonstrated

* Terraform Functions
* split()
* join()
* for Expressions
* AWS Security Groups
* Infrastructure as Code
* DevOps Automation

### Assignment Status

✅ Completed

### Functions Covered

* split()
* join()
* for expression

### Difficulty

⭐⭐ Intermediate

Part of the **#30DaysOfAWSTerraform** challenge.
