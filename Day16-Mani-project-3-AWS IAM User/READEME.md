# Day 16 - AWS IAM User Management & Automated Onboarding with Terraform

## Project Overview

This project automates AWS IAM user onboarding using Terraform. Instead of manually creating IAM users, groups, login profiles, and policies through the AWS Console, all user information is maintained in a CSV file and Terraform dynamically provisions the required resources.

The project demonstrates Infrastructure as Code (IaC), user lifecycle management, role-based access control (RBAC), MFA enforcement, and remote state management.

---

# Architecture

```text
users.csv
    │
    ▼
csvdecode()
    │
    ▼
Terraform Locals
    │
    ▼
for_each Loop
    │
    ├── IAM Users
    ├── Login Profiles
    ├── User Tags
    ├── Group Memberships
    └── Policy Attachments
            │
            ▼
       MFA Enforcement
```

---

# Technologies Used

* Terraform
* AWS IAM
* AWS S3 Backend
* CSV Data Source
* AWS Provider
* AWS CLI

---

# Features Implemented

### IAM User Creation

Created IAM users dynamically from a CSV file using Terraform.

### Automated User Onboarding

User information is maintained in a CSV file and automatically converted into AWS IAM users.

### IAM Login Profiles

Generated login profiles for all users and forced password reset on first login.

### IAM Groups

Created IAM groups to organize users based on business roles.

### Group Membership Automation

Automatically assigned users to groups based on department values.

### IAM Policy Attachments

Attached AWS managed policies to IAM groups.

### MFA Enforcement

Implemented a custom IAM policy requiring users to enable Multi-Factor Authentication.

### User Metadata Tags

Added additional user information:

* Email
* Phone Number
* Department
* Job Title

### Remote State Management

Stored Terraform state remotely in an S3 bucket.

---

# Project Structure

```text
Day16-IAM-User-Management/
│
├── backend.tf
├── provider.tf
├── main.tf
├── groups.tf
├── mfa-policy.tf
├── outputs.tf
├── users.csv
├── terraform.tfvars
├── .gitignore
└── README.md
```

---

# Understanding the Core Concepts

## csvdecode()

### Purpose

Converts CSV data into Terraform objects.

### Code

```hcl
locals {
  users = csvdecode(file("users.csv"))
}
```

### Example CSV

```csv
first_name,last_name,department,job_title,email,phone
Michael,Scott,Education,Regional Manager,michael@company.com,9876543210
```

### Why It Is Useful

Instead of manually creating users in Terraform, HR or administrators can simply update a CSV file.

### Real-World Use Case

A company hires 100 employees.

Without csvdecode():

* Create 100 IAM users manually.

With csvdecode():

* Add users to CSV.
* Run terraform apply.

Terraform handles everything automatically.

---

## for_each

### Purpose

Creates multiple resources dynamically.

### Code

```hcl
resource "aws_iam_user" "royal" {
  for_each = {
    for user in local.users :
    user.first_name => user
  }
}
```

### Why It Is Useful

Without for_each:

```hcl
resource "aws_iam_user" "user1" {}
resource "aws_iam_user" "user2" {}
resource "aws_iam_user" "user3" {}
```

With for_each:

Terraform automatically creates all users from CSV.

### Benefit

* Less code
* Better scalability
* Easier maintenance

---

## AWS Caller Identity

### Code

```hcl
data "aws_caller_identity" "current" {}
```

### Purpose

Retrieves:

* Account ID
* ARN
* User ID

### Use Case

Useful when creating reusable Terraform modules that need the current AWS account information.

---

## IAM Login Profiles

### Code

```hcl
resource "aws_iam_user_login_profile" "example" {
  for_each = aws_iam_user.royal

  user = each.value.name

  password_reset_required = true
}
```

### Purpose

Creates console login access for IAM users.

### Security Benefit

Users must reset passwords during first login.

---

## IAM Group Membership

### Purpose

Assign users automatically to groups.

### Example

```hcl
resource "aws_iam_group_membership" "education_members" {
  group = aws_iam_group.education.name

  users = [
    for user in aws_iam_user.royal :
    user.name if user.tags.Department == "Education"
  ]
}
```

### Benefit

Role-Based Access Control (RBAC).

---

## MFA Enforcement

### Purpose

Prevent users from accessing AWS resources without MFA.

### Benefit

* Improved security
* Protection against compromised passwords
* Enterprise security best practice

---

## S3 Backend

### Code

```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "iam-project/terraform.tfstate"
    region = "us-east-1"
  }
}
```

### Benefits

* Centralized state
* Team collaboration
* State recovery
* Version control

---

# Challenges Faced

## 1. Understanding for_each

Initially, I struggled with creating resources dynamically from CSV data.

The challenge was understanding:

* Maps
* Objects
* each.key
* each.value

After several experiments, I learned how Terraform iterates through data and creates resources automatically.

---

## 2. IAM Policy Attachments

I faced difficulties attaching policies to the correct groups.

Challenges:

* Understanding policy ARNs
* Group references
* Permission assignment

After troubleshooting, I successfully attached:

* ReadOnlyAccess
* AdministratorAccess
* RequireMFA

to the appropriate groups.

---

## 3. CSV Formatting Errors

While adding email and phone fields, Terraform produced:

```text
csvdecode() failed:
wrong number of fields
```

Root Cause:

A missing comma in one CSV row.

Solution:

Validated all CSV records and ensured every row had the same number of fields.

---

## 4. AWS Provider Compatibility

Some configurations behaved differently with newer AWS provider releases.

### Solution

Pinned provider version:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

After using AWS Provider 5.x, the project worked correctly.

---

# Interview Questions & Answers

## What is csvdecode()?

csvdecode() converts CSV data into a Terraform list of objects.

It is useful when infrastructure needs to be generated from spreadsheets or HR data.

---

## Why use for_each instead of count?

for_each provides stable resource identifiers using keys.

count uses indexes which may change when resources are added or removed.

for_each is preferred for managing users and other dynamic resources.

---

## What is AWS Caller Identity?

AWS Caller Identity retrieves information about the currently authenticated AWS account.

It provides:

* Account ID
* ARN
* User ID

---

## Why use IAM Groups?

IAM Groups simplify permission management.

Instead of assigning permissions to individual users, permissions are assigned to groups.

---

## What is MFA?

Multi-Factor Authentication adds an extra layer of security.

Users must provide:

* Password
* Authentication code

before accessing AWS resources.

---

## What is an S3 Backend?

An S3 backend stores Terraform state remotely.

Benefits:

* Team collaboration
* State locking
* Centralized management
* Disaster recovery

---

## How did you automate onboarding?

I used:

* CSV files
* csvdecode()
* for_each
* IAM Users
* Login Profiles
* Group Memberships

This allows new employees to be onboarded simply by updating a CSV file.

---

## What is the biggest learning from this project?

Understanding how Terraform can dynamically create infrastructure from external data sources and automate IAM user lifecycle management using Infrastructure as Code principles.

---

# Future Enhancements

* AWS IAM Identity Center (AWS SSO)
* HR System Integration
* Dynamic Department Group Creation
* Password Policy Enforcement
* CloudTrail Auditing
* Automated Offboarding Workflow

---

# Conclusion

This project demonstrates a production-style IAM onboarding solution using Terraform. By combining csvdecode(), for_each, IAM Groups, Policy Attachments, MFA Enforcement, and S3 Backend state management, the solution automates user lifecycle management while improving security, consistency, and scalability.



Learning Resources
Terraform Learn
https://developer.hashicorp.com/terraform/tutorials
AWS Skill Builder
https://skillbuilder.aws


Project Links
GitHub Repository:
https://github.com/Ramana175/30DaysOfAWSTerraform.git
LinkedIn Post:
https://linkedin.com/in/venkataramanasanga
Blog Post:
(https://venkataramana.hashnode.dev)