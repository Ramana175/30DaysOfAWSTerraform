# Terraform Functions Learning Module - AWS Edition (Days 11-12)

## 📖 Overview

A comprehensive, hands-on learning guide to mastering **Terraform's 50+ built-in functions** through 12 graded assignments with real AWS use cases. Covers string manipulation, validation, sensitive data handling, file operations, and more—all tested in production environments.

**Perfect For:**
- Engineers transitioning from SysOps/NOC to DevOps/Cloud
- Teams building scalable, reusable IaC
- Anyone interviewing for DevOps/SRE/Platform Engineering roles
- Terraform practitioners looking to deepen their skills

---

## 🎯 Learning Objectives

By the end of this module, you will:

✅ Master Terraform's built-in functions across **8 categories**  
✅ Know **when and how** to use each function type  
✅ Combine multiple functions for production-grade IaC  
✅ Validate input before infrastructure is provisioned  
✅ Handle sensitive data (and understand the limitations)  
✅ Build dynamic, reusable configurations  
✅ Debug functions using `terraform console`  
✅ Pass technical interviews on Terraform deep dives  

---

## 📂 Repository Structure

```
terraform-functions-learning/
├── README.md                 # This file
├── BLOG_POST.md             # Deep-dive blog with patterns & best practices
├── DEMO_GUIDE.md            # Step-by-step walkthrough for each assignment
│
├── provider.tf              # AWS provider configuration
├── backend.tf               # Optional S3 backend setup
├── variables.tf             # All assignment input variables
├── main.tf                  # 12 commented assignments (uncomment to activate)
├── outputs.tf               # Assignment outputs (commented)
├── terraform.tfvars         # Example variable values
│
└── assignments/             # (Optional) Individual assignment folders
    ├── 01-project-naming/
    ├── 02-resource-tagging/
    ├── 03-s3-bucket-naming/
    └── ... (10 more)
```

---

## 🚀 Quick Start (5 minutes)

### Prerequisites
- Terraform v1.0+ (`terraform -v`)
- AWS credentials configured (`aws configure` or env vars)
- Bash shell or PowerShell

### Step 1: Clone & Navigate
```bash
git clone https://github.com/royalvenkataram/terraform-functions-learning.git
cd terraform-functions-learning/lessons/day11-12
```

### Step 2: Initialize Terraform
```bash
terraform init
```

### Step 3: View Assignment 1 (Active by Default)
```bash
# See what will be created
terraform plan

# Apply the first assignment
terraform apply -auto-approve
```

### Step 4: View Results
```bash
# Display outputs from Assignment 1
terraform output

# Example output:
# normalized_project_name = "project-alpha-resource"
```

### Step 5: Try More Assignments
Uncomment Assignment 2-12 in `main.tf` and repeat:
```bash
# In main.tf, find:
# # Assignment 2: Resource Tagging
# Uncomment the block below:
# resource "aws_vpc" "default_tags" { ... }

terraform plan
terraform apply -auto-approve
terraform output
```

### Step 6: Cleanup
```bash
# Destroy all created resources
terraform destroy -auto-approve
```

---

## 📋 The 12 Assignments

### Assignment 1: Project Naming ⭐ **[START HERE]**
**Functions:** `lower()`, `replace()`  
**Goal:** Transform "Project ALPHA Resource" → "project-alpha-resource"  
**AWS Resources:** None (local values only)  
**Use Case:** Enforce naming conventions before creating infrastructure

```hcl
locals {
  project_name = "Project ALPHA Resource"
  normalized = lower(replace(project_name, " ", "-"))
}

output "normalized_project_name" {
  value = local.normalized
}
```

**Learning:** String functions are the foundation of dynamic infrastructure.

---

### Assignment 2: Resource Tagging ⭐
**Functions:** `merge()`  
**Goal:** Combine default tags with environment-specific tags  
**AWS Resources:** VPC  
**Use Case:** Enforce consistent tagging across resources

```hcl
locals {
  default_tags = {
    Project   = "infrastructure"
    ManagedBy = "Terraform"
  }
  env_tags = {
    Environment = var.environment
    Owner       = var.owner
  }
  all_tags = merge(local.default_tags, local.env_tags)
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = local.all_tags
}
```

**Learning:** `merge()` prevents tag duplication and enforces governance.

---

### Assignment 3: S3 Bucket Naming ⭐⭐
**Functions:** `substr()`, `replace()`, `lower()`  
**Goal:** Sanitize bucket names for AWS compliance (lowercase, no underscores, <63 chars)  
**AWS Resources:** S3 Bucket  
**Use Case:** Ensure resource names meet AWS naming constraints

```hcl
locals {
  raw_name = "MY_PROJECT_BUCKET_NAME"
  
  # Step 1: lowercase
  lowered = lower(local.raw_name)
  
  # Step 2: remove underscores
  sanitized = replace(local.lowered, "_", "-")
  
  # Step 3: ensure < 63 chars
  final_name = substr(local.sanitized, 0, 63)
}

resource "aws_s3_bucket" "app_data" {
  bucket = local.final_name
}
```

**Learning:** Chaining functions prevents AWS errors before they happen.

---

### Assignment 4: Security Group Ports ⭐⭐
**Functions:** `split()`, `join()`, `for`  
**Goal:** Transform "80,443,8080" into individual ingress rules  
**AWS Resources:** Security Group  
**Use Case:** Parse comma-separated input into iterable lists

```hcl
variable "allowed_ports" {
  type    = string
  default = "80,443,8080"
}

locals {
  port_list = split(",", var.allowed_ports)
}

resource "aws_security_group" "web" {
  name = "web-sg"
  
  dynamic "ingress" {
    for_each = local.port_list
    content {
      from_port   = tonumber(ingress.value)
      to_port     = tonumber(ingress.value)
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

**Learning:** `split()` + `for` enables dynamic block iteration.

---

### Assignment 5: Environment Lookup ⭐⭐
**Functions:** `lookup()`  
**Goal:** Select instance size based on environment (dev → t2.micro, prod → t3.large)  
**AWS Resources:** EC2 Instance  
**Use Case:** Map input values to pre-defined configurations

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

locals {
  instance_types = {
    dev     = "t2.micro"
    staging = "t3.small"
    prod    = "t3.large"
  }
  selected_type = lookup(local.instance_types, var.environment, "t2.micro")
}

resource "aws_instance" "app" {
  instance_type = local.selected_type
  ami           = data.aws_ami.latest.id
}
```

**Learning:** `lookup()` eliminates if/else chains.

---

### Assignment 6: Instance Validation ⭐⭐⭐
**Functions:** `length()`, `can()`, `regex()`  
**Goal:** Validate instance type format (must be t2/t3 family)  
**AWS Resources:** EC2 Instance  
**Use Case:** Enforce naming/format standards at variable level

```hcl
variable "instance_type" {
  type    = string
  default = "t3.medium"
  
  validation {
    condition = (
      length(var.instance_type) >= 6 &&
      can(regex("^t[2-3]\\.[a-z]+$", var.instance_type))
    )
    error_message = "Must be t2 or t3 family (e.g., t3.medium). Got: ${var.instance_type}"
  }
}
```

**Learning:** Validation catches errors before apply, with custom error messages.

---

### Assignment 7: Backup Configuration ⭐⭐
**Functions:** `endswith()`, `sensitive`  
**Goal:** Validate backup name ends with "-backup" and hide password from logs  
**AWS Resources:** None  
**Use Case:** Enforce naming conventions + protect secrets

```hcl
variable "backup_name" {
  type = string
  
  validation {
    condition     = endswith(var.backup_name, "-backup")
    error_message = "Backup name must end with '-backup'. Got: ${var.backup_name}"
  }
}

variable "db_password" {
  type      = string
  sensitive = true  # Hides value from plan/apply output
}

output "backup_config" {
  value = {
    name     = var.backup_name
    password = "***REDACTED***"  # Manually hide in output
  }
  sensitive = false
}
```

**Learning:** `sensitive = true` prevents log leaks (but not state file exposure).

---

### Assignment 8: File Path Processing ⭐⭐
**Functions:** `fileexists()`, `dirname()`, `basename()`  
**Goal:** Check if config file exists and extract path components  
**AWS Resources:** None  
**Use Case:** Work with local files for dynamic configuration

```hcl
variable "config_path" {
  type    = string
  default = "./config/app-config.json"
}

locals {
  config_exists = fileexists(var.config_path)
  config_dir    = dirname(var.config_path)
  config_file   = basename(var.config_path)
  
  # Safe to use only if file exists
  config_data = local.config_exists ? jsondecode(file(var.config_path)) : {}
}

output "config_info" {
  value = {
    exists = local.config_exists
    dir    = local.config_dir
    file   = local.config_file
  }
}
```

**Learning:** Always check `fileexists()` before `file()`.

---

### Assignment 9: Location Management ⭐
**Functions:** `toset()`, `concat()`  
**Goal:** Combine multiple region lists and remove duplicates  
**AWS Resources:** None  
**Use Case:** Manage multi-region deployments without redundancy

```hcl
locals {
  regions_us = ["us-east-1a", "us-east-1b", "us-east-1a"]
  regions_eu = ["us-east-1b", "eu-west-1a"]
  
  # Combine and deduplicate
  all_regions = toset(concat(local.regions_us, local.regions_eu))
}

output "unique_regions" {
  value = local.all_regions
  # Output: toset(["us-east-1a", "us-east-1b", "eu-west-1a"])
}
```

**Learning:** `toset()` automatically removes duplicates.

---

### Assignment 10: Cost Calculation ⭐⭐
**Functions:** `abs()`, `max()`, `min()`, `sum()`  
**Goal:** Calculate total cost after credits, find highest expense  
**AWS Resources:** None  
**Use Case:** FinOps tracking within Terraform

```hcl
locals {
  monthly_costs = [1250, 3400, 890, 2100]
  monthly_credit = 500
  
  # Numeric operations with spread operator
  total_cost = sum(local.monthly_costs...)
  max_month_cost = max(local.monthly_costs...)
  min_month_cost = min(local.monthly_costs...)
  
  # Final cost after credits
  net_cost = abs(local.total_cost - local.monthly_credit)
}

output "cost_summary" {
  value = {
    total     = local.total_cost
    max       = local.max_month_cost
    min       = local.min_month_cost
    net_cost  = local.net_cost
  }
}
```

**Learning:** Spread operator (`...`) unpacks lists for numeric functions.

---

### Assignment 11: Timestamp Management ⭐⭐
**Functions:** `timestamp()`, `formatdate()`  
**Goal:** Tag resources with creation timestamp in readable format  
**AWS Resources:** S3 Bucket  
**Use Case:** Compliance & audit trails

```hcl
locals {
  created_at_iso = timestamp()
  created_at_readable = formatdate("YYYY-MM-DD HH:mm:ss Z", timestamp())
}

resource "aws_s3_bucket" "audit_logs" {
  bucket = "audit-logs-${var.environment}"
  
  tags = {
    CreatedAt = local.created_at_readable
    CreatedBy = "Terraform"
  }
}

output "bucket_creation_time" {
  value = local.created_at_readable
}
```

**Learning:** `timestamp()` is computed at apply time, not plan time.

---

### Assignment 12: File Content Handling ⭐⭐⭐
**Functions:** `file()`, `jsondecode()`, `jsonencode()`  
**Goal:** Read JSON config, validate, and store in Secrets Manager  
**AWS Resources:** Secrets Manager Secret  
**Use Case:** Inject external configuration into infrastructure

```hcl
locals {
  config_path = "${path.module}/app-config.json"
  
  # Step 1: Check file exists
  # Step 2: Read file
  # Step 3: Parse JSON
  config = jsondecode(file(local.config_path))
}

resource "aws_secretsmanager_secret" "app_config" {
  name                    = "${local.config.app_name}-config"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "app_config" {
  secret_id      = aws_secretsmanager_secret.app_config.id
  secret_string  = jsonencode(local.config)
}

output "secret_arn" {
  value = aws_secretsmanager_secret.app_config.arn
}
```

**Learning:** JSON files enable dynamic, external configuration management.

---

## 🎓 Function Category Reference

| **Category** | **Functions** | **Use Case** |
|---|---|---|
| **String** | `lower`, `upper`, `substr`, `replace`, `trim`, `split`, `join` | Naming conventions, parsing |
| **Numeric** | `abs`, `max`, `min`, `sum`, `ceil`, `floor` | Cost, counts, aggregations |
| **Collection** | `length`, `merge`, `concat`, `reverse`, `toset`, `tolist` | Tag merging, deduplication |
| **Type Conversion** | `tonumber`, `tostring`, `tobool`, `toset`, `tolist` | Data transformation |
| **File** | `file`, `fileexists`, `dirname`, `basename` | Local file operations |
| **Date/Time** | `timestamp`, `formatdate`, `timeadd` | Tagging, compliance |
| **Validation** | `can`, `regex`, `contains`, `startswith`, `endswith` | Input validation |
| **Lookup** | `lookup`, `element`, `index` | Map/list lookups |

---

## 🛠️ Testing Functions in `terraform console`

Before using functions in code, test them interactively:

```bash
terraform console

# String functions
> lower("HELLO WORLD")
"hello world"

> replace("hello_world", "_", "-")
"hello-world"

> substr("terraform-functions", 0, 9)
"terraform"

# Numeric functions
> max(5, 12, 9)
12

> sum([10, 20, 30])
60

# Collection functions
> merge({a = 1}, {b = 2})
{"a" = 1, "b" = 2}

> toset(["a", "b", "a"])
toset(["a", "b"])

# Validation
> can(regex("^t[2-3]", "t3.medium"))
true

> endswith("my-backup", "-backup")
true

# Date/time
> timestamp()
"2026-06-03T14:32:15Z"

> formatdate("YYYY-MM-DD", timestamp())
"2026-06-03"

# Exit console
> exit
```

---

## 📚 Deep Learning Resources

1. **BLOG_POST.md** — Complete guide with patterns, best practices, and common mistakes
2. **DEMO_GUIDE.md** — Step-by-step walkthrough of each assignment
3. [Terraform Built-in Functions](https://www.terraform.io/language/functions) — Official docs
4. [Terraform Console](https://www.terraform.io/cli/commands/console) — Interactive testing
5. [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) — Resource reference

---

## ⚠️ Common Pitfalls & Solutions

| **Problem** | **Solution** |
|---|---|
| `max()` fails with a list | Use spread operator: `max(list...)` |
| Sensitive output leaks value | Mark output as `sensitive = true` |
| File not found at apply | Always use `fileexists()` first |
| Can't iterate over set | Convert with `tolist(toset(...))` |
| Regex in validation doesn't work | Test in `terraform console` first |
| State file still contains secrets | Use Vault/Secrets Manager for rotation |

---

## 🚀 What's Next?

After completing these assignments:

1. **Build Your Own:** Create a module combining 3+ functions
2. **Contribute:** Submit a PR with your own assignment idea
3. **Interview Prep:** Use the BLOG_POST as a talking point for DevOps interviews
4. **Production Use:** Apply these patterns to your real infrastructure

---

## 📊 Assignment Difficulty Breakdown

- **⭐ (Beginner):** 1, 2, 9 — Core string/collection basics
- **⭐⭐ (Intermediate):** 3, 4, 5, 7, 8, 10, 11 — Combining functions, validation intro
- **⭐⭐⭐ (Advanced):** 6, 12 — Complex validation, external config parsing

---

## 💡 Pro Tips

1. **Test in console first** — Never write functions directly in code. Test in `terraform console` first.
2. **Use `terraform fmt`** — Keep code formatting consistent.
3. **Validate before apply** — Catch errors at plan time with validation blocks.
4. **Document your functions** — Add comments explaining why you chose that function.
5. **Version lock your provider** — Use `required_providers` to ensure function availability.

---

## 🤝 Contributing

Found a bug or have a better solution? Submit an issue or PR!

```bash
git checkout -b feature/assignment-X-improvement
# Make changes
git commit -m "Improve Assignment X: [description]"
git push origin feature/assignment-X-improvement
```

---

## 📄 License

MIT License — Use freely in your projects and learning.

---

## 👨‍💻 About the Author

**Royal | NOC Engineer → DevOps Engineer**

Managing 50+ servers in production with 99.9% uptime SLA and 100+ incidents/month. Built this module to help engineers transition from operations to infrastructure engineering.

- 🔗 [LinkedIn](https://linkedin.com/in/venkataramanasanga)
- 🐙 [GitHub](https://github.com/royalvenkataram)
- 📍 Bengaluru | Open to DevOps, SRE, Cloud, Platform Engineering roles pan-India & Remote

---

## ❓ FAQ

**Q: Can I use these assignments in my interview prep?**  
A: Absolutely! The BLOG_POST.md is written specifically for that.

**Q: Do I need AWS credits?**  
A: Some assignments create resources (VPC, S3, EC2). Use free tier or `terraform destroy` after.

**Q: Can I do assignments out of order?**  
A: Yes, but start with 1-5 for foundation. 6-12 build on earlier concepts.

**Q: How long does this module take?**  
A: 6-8 hours for all assignments + deep learning. ~30 min per assignment.

**Q: Will this help me get a DevOps job?**  
A: It demonstrates production-grade Terraform skills and makes for great interview talking points.

---

**Last Updated:** June 2026  
**Version:** 1.0.0  
**Status:** Active & Maintained