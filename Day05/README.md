# Day 05 — Terraform Variables: Input, Local & Output

> Part of the [#30DaysOfAWSTerraform](https://hashnode.com/n/30daysofawsterraform) challenge by [Piyush Sachdeva](https://www.linkedin.com/in/piyush-sachdeva)

---

## Topics Covered

- Input Variables — types, defaults, and how to pass values
- Local Variables — internal computed values and string concatenation
- Output Variables — exposing values after deployment
- Variable precedence hierarchy
- Testing different variable methods

---

## Variable Types Overview

| Type | Prefix | File | Purpose |
|---|---|---|---|
| Input | `var.` | `variables.tf` | External parameters |
| Local | `local.` | `locals.tf` | Internal computed values |
| Output | — | `output.tf` | Return values after apply |

---

## Variable Precedence (low → high)

```
default  →  TF_VAR_*  →  terraform.tfvars  →  -var-file  →  -var flag
```

`-var` flag always wins. Use it deliberately.

---

## Project Structure

```
day05/
├── main.tf            # S3 bucket resource
├── variables.tf       # Input variable definitions
├── locals.tf          # Local computed values + random suffix
├── output.tf          # Output variable definitions
├── provider.tf        # AWS + random provider config
├── terraform.tfvars   # Default variable values (auto-loaded)
├── dev.tfvars         # Dev environment values
├── production.tfvars  # Production environment values
└── README.md          # This file
```

---

## Configuration

### `variables.tf`
```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "bucket_name" {
  description = "S3 bucket base name"
  type        = string
  default     = "my-terraform-bucket"
}
```

### `locals.tf`
```hcl
locals {
  full_bucket_name = "${var.environment}-${var.bucket_name}-${random_string.suffix.result}"

  common_tags = {
    Environment = var.environment
    Project     = "Terraform-Demo"
    Owner       = "DevOps-Team"
  }
}
```

### `output.tf`
```hcl
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.demo.arn
}

output "environment" {
  description = "Environment deployed"
  value       = var.environment
}

output "tags" {
  description = "Tags applied to resources"
  value       = local.common_tags
}
```

### `terraform.tfvars`
```hcl
environment = "demo"
bucket_name = "terraform-demo-bucket"
```

---

## Workflow

```bash
# Initialize
terraform init

# Plan with defaults
terraform plan

# Plan with command line override
terraform plan -var="environment=production"

# Plan with different tfvars file
terraform plan -var-file="dev.tfvars"

# Apply and view outputs
terraform apply
terraform output
terraform output -json
terraform output -raw bucket_name

# Clean up
terraform destroy
```

---

## Testing Variable Precedence

```bash
# Test 1: Default values (hide tfvars)
mv terraform.tfvars terraform.tfvars.backup
terraform plan   # environment = "staging"
mv terraform.tfvars.backup terraform.tfvars

# Test 2: terraform.tfvars auto-loaded
terraform plan   # environment = "demo"

# Test 3: Command line (highest precedence)
terraform plan -var="environment=production"

# Test 4: Environment variable
export TF_VAR_environment="from-env-var"
terraform plan
unset TF_VAR_environment

# Test 5: Different tfvars files
terraform plan -var-file="dev.tfvars"
terraform plan -var-file="production.tfvars"
```

---

## Variable Data Types

**Primitive:**
```hcl
type = string    # "us-east-1"
type = number    # 3
type = bool      # true
```

**Complex:**
```hcl
type = list(string)              # ["a", "b", "c"]
type = map(string)               # { key = "value" }
type = object({ name = string }) # structured
type = set(string)               # unique list
type = tuple([string, number])   # mixed types
```

**Special:**
```hcl
type = any    # Terraform infers the type
type = null   # No type constraint
```

---

## Key Takeaways

- Input variables parameterize config — change values without touching code
- Local variables enforce DRY — compute once, reference everywhere
- Output variables expose what matters — bucket names, ARNs, IDs
- `-var` flag is the highest precedence — use it for one-off overrides
- Separate `.tfvars` per environment = same code, different inputs, zero drift

---

## Resources

- [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Terraform Local Values](https://developer.hashicorp.com/terraform/language/values/locals)
- [Terraform Output Values](https://developer.hashicorp.com/terraform/language/values/outputs)
- [GitHub: Full Repo](https://github.com/Ramana175/30DaysOfAWSTerraform)

---

## Next Steps

**Day 06** — Terraform Modules: reusable infrastructure components.

---

*Day 05 of 30 — [Follow the journey on LinkedIn](https://www.linkedin.com/in/venkataramanasanga)*