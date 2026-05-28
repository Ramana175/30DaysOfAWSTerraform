# Day 06 — Terraform File Structure & Project Organization

> Part of the [#30DaysOfAWSTerraform](https://hashnode.com/n/30daysofawsterraform) challenge by [Piyush Sachdeva](https://www.linkedin.com/in/piyush-sachdeva)

---

## Topics Covered

- Terraform file loading order (lexicographical)
- Recommended file structure and separation of concerns
- `.gitignore` best practices for security
- Environment management patterns
- `terraform fmt` and `terraform validate`

---

## Project Structure

```
day06/
├── backend.tf                # Remote state + provider versions
├── provider.tf               # AWS provider config
├── variables.tf              # All input variable definitions
├── locals.tf                 # Computed names + common tags
├── main.tf                   # Core resources
├── vpc.tf                    # VPC, subnets, routing, IGW
├── storage.tf                # S3 bucket + versioning + encryption
├── outputs.tf                # Output values
├── terraform.tfvars          # ⚠ Variable values — NEVER commit
├── terraform.tfvars.example  # ✓ Template — safe to share
├── .gitignore                # Protects sensitive files
└── README.md                 # This file
```

---

## File Loading Order

Terraform loads all `.tf` files alphabetically and merges them:

```
backend.tf → locals.tf → main.tf → outputs.tf → provider.tf → variables.tf → vpc.tf
```

Order doesn't affect functionality — Terraform resolves dependencies automatically.
Order affects **navigability** — your ability to find things fast.

---

## Key Files

### `backend.tf`
```hcl
terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "your-terraform-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
```

### `locals.tf`
```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  })
}
```

### `provider.tf`
```hcl
provider "aws" {
  region = var.region

  default_tags {
    tags = local.common_tags
  }
}
```

### `variables.tf`
```hcl
variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
```

### `main.tf`
```hcl
# Random ID for globally unique bucket names
resource "random_id" "suffix" {
  byte_length = 4

  keepers = {
    project     = var.project_name
    environment = var.environment
  }
}

# S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
  tags   = local.common_tags
}

# S3 Versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# S3 Block Public Access
resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

### `outputs.tf`
```hcl
# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

# S3 Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket_domain_name
}

# Environment Outputs
output "environment" {
  description = "Environment deployed"
  value       = var.environment
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
}
```

### `terraform.tfvars`
```hcl
project_name       = "aws-terraform-course"
environment        = "demo"
region             = "us-east-1"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

tags = {
  Owner      = "DevOps-Team"
  Department = "Engineering"
  CostCenter = "Engineering-001"
}
```

---

## .gitignore — Never Commit These

```
.terraform/
terraform.tfstate
terraform.tfstate.backup
*.tfstate
*.tfstate.*
terraform.tfvars
crash.log
*.log
```

**Always commit:** `terraform.tfvars.example` and `.terraform.lock.hcl`

---

## Environment Management

**Variable-based (simple projects):**
```bash
terraform plan -var-file="dev.tfvars"
terraform plan -var-file="production.tfvars"
```

**Directory-based (maximum isolation):**
```
environments/
├── dev/
├── staging/
└── production/
```

---

## Workflow

```bash
# Format all files
terraform fmt -recursive

# Validate structure
terraform validate

# Plan
terraform plan

# Full pre-commit check
terraform fmt -recursive && terraform validate && terraform plan
```

---

## Key Takeaways

- All `.tf` files auto-loaded alphabetically — no manual imports needed
- One concern per file — navigability is an engineering discipline
- Never commit `tfstate` or `tfvars` — use `.gitignore`
- Always commit `tfvars.example` — document what teammates need
- `terraform fmt -recursive` before every commit

---

## Resources

- [Terraform File Structure](https://developer.hashicorp.com/terraform/language/files)
- [Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style)
- [Full Repo](https://github.com/Ramana175/30DaysOfAWSTerraform)

---

*Day 06 of 30 — [Follow the journey on LinkedIn](https://www.linkedin.com/in/venkataramanasanga)*