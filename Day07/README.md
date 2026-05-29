# Day 07 — Terraform Variable Type Constraints

> Part of the [#30DaysOfAWSTerraform](https://hashnode.com/n/30daysofawsterraform) challenge by [Piyush Sachdeva](https://www.linkedin.com/in/piyush-sachdeva)

---

## Topics Covered

- Primitive types: string, number, bool
- Complex types: list, set, map, tuple, object
- Special types: any, null
- Validation blocks
- Key interview distinctions: list vs set, map vs object

---

## Primitive Types

### string
```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Must be dev, staging, or production."
  }
}
```

### number
```hcl
variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

variable "port" {
  description = "Application port"
  type        = number
  default     = 8080
}
```

### bool
```hcl
variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

variable "associate_public_ip" {
  description = "Associate public IP to instance"
  type        = bool
  default     = false
}
```

---

## Complex Types

### list(type) — Ordered, Indexed, Duplicates Allowed
```hcl
variable "availability_zones" {
  description = "List of AZs"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Access by index
# var.availability_zones[0] → "us-east-1a"
# var.availability_zones[1] → "us-east-1b"
```

### set(type) — Unique Values, No Direct Index
```hcl
variable "allowed_instance_types" {
  description = "Allowed EC2 instance types"
  type        = set(string)
  default     = ["t2.micro", "t3.small", "t3.medium"]
}

# Cannot access by index directly
# Convert first: tolist(var.allowed_instance_types)[0]
# Duplicates are automatically removed
```

### map(type) — Key-Value Pairs, Same Value Type
```hcl
variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {
    Environment = "staging"
    Team        = "DevOps"
    ManagedBy   = "Terraform"
  }
}

# Access by key
# var.tags["Environment"] → "staging"
# var.tags["Team"]        → "DevOps"
```

### tuple([type1, type2...]) — Fixed Length, Mixed Types, Indexed
```hcl
variable "instance_config" {
  description = "Instance type, count, and monitoring flag"
  type        = tuple([string, number, bool])
  default     = ["t2.micro", 2, true]
}

# Access by index
# var.instance_config[0] → "t2.micro"
# var.instance_config[1] → 2
# var.instance_config[2] → true
```

### object({}) — Named Attributes, Each With Own Type
```hcl
variable "server_config" {
  description = "Complete server configuration"
  type = object({
    instance_type  = string
    instance_count = number
    monitoring     = bool
    tags           = map(string)
  })
  default = {
    instance_type  = "t2.micro"
    instance_count = 1
    monitoring     = true
    tags           = { Environment = "dev" }
  }
}

# Access with dot notation
# var.server_config.instance_type  → "t2.micro"
# var.server_config.instance_count → 1
# var.server_config.monitoring     → true
```

---

## Special Types

### any
```hcl
variable "flexible_value" {
  type    = any
  default = "Terraform infers the type"
}
```

### null
```hcl
variable "optional_setting" {
  type    = string
  default = null   # Resource falls back to its own default
}
```

---

## Validation Block Pattern

```hcl
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}
```

Catches bad values **before** any API call is made.

---

## Key Interview Distinctions

### list vs set

| | list | set |
|---|---|---|
| Order | Preserved | Not guaranteed |
| Duplicates | Allowed | Auto-removed |
| Access | `var.list[0]` | `tolist(var.set)[0]` |
| Use case | AZ lists, subnet CIDRs | Unique instance types |

### map vs object

| | map | object |
|---|---|---|
| Value types | All same type | Each key has own type |
| Access | `var.tags["key"]` | `var.config.key` |
| Use case | Resource tags | Full resource config |

---

## Project Structure

```
day07/
├── main.tf          # Resources using type-constrained variables
├── variables.tf     # All variable definitions with types + validation
├── outputs.tf       # Output values
├── provider.tf      # AWS provider
├── terraform.tfvars # Variable values
└── README.md        # This file
```

---

## Workflow

```bash
terraform init
terraform validate    # Catches type errors immediately
terraform plan
terraform apply
terraform destroy
```

---

## Resources

- [Terraform Type Constraints](https://developer.hashicorp.com/terraform/language/expressions/type-constraints)
- [Terraform Validation Rules](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules)
- [Full Repo](https://github.com/Ramana175/30DaysOfAWSTerraform)

---

*Day 07 of 30 — [Follow the journey on LinkedIn](https://www.linkedin.com/in/venkataramanasanga)*