# Day 09 — Terraform Lifecycle Meta-Arguments

> Part of the [#30DaysOfAWSTerraform](https://hashnode.com/n/30daysofawsterraform) challenge by [Piyush Sachdeva](https://www.linkedin.com/in/piyush-sachdeva)

---

## Topics Covered

- `create_before_destroy` — zero-downtime deployments
- `prevent_destroy` — protect critical resources
- `ignore_changes` — handle external modifications
- `replace_triggered_by` — dependency-based replacements
- `precondition` — pre-deployment validation
- `postcondition` — post-deployment validation

---

## create_before_destroy

```hcl
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}
```

Default: destroy old → create new → downtime gap
With this: create new → switch → destroy old → zero downtime

Use for: EC2 behind load balancers, RDS instances, any resource that cannot have a gap.

---

## prevent_destroy

```hcl
resource "aws_db_instance" "production" {
  identifier = "prod-database"
  engine     = "mysql"

  lifecycle {
    prevent_destroy = true
  }
}
```

Blocks `terraform destroy` with a hard error. To remove:
1. Comment out `prevent_destroy = true`
2. Run `terraform apply`
3. Now destroy is allowed

Use for: production databases, critical S3 buckets, compliance resources.

---

## ignore_changes

```hcl
resource "aws_autoscaling_group" "app" {
  name             = "app-asg"
  desired_capacity = 2
  min_size         = 1
  max_size         = 10

  lifecycle {
    ignore_changes = [
      desired_capacity,   # AWS auto-scaling manages this
      load_balancers,     # Added externally
    ]
  }
}

# Ignore ALL changes
lifecycle {
  ignore_changes = all
}
```

Use for: ASG capacity, tags managed by monitoring tools, passwords managed by Secrets Manager.

---

## replace_triggered_by

```hcl
resource "aws_security_group" "app_sg" {
  name = "app-security-group"
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]
  }
}
```

SG changes → EC2 instance completely replaced → fresh server with new rules.

Use for: immutable infrastructure patterns, config-driven forced replacements.

---

## precondition

```hcl
variable "allowed_regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-2"]
}

resource "aws_s3_bucket" "regional" {
  bucket = "my-regional-bucket"

  lifecycle {
    precondition {
      condition     = contains(var.allowed_regions, data.aws_region.current.name)
      error_message = "Deployment only allowed in: ${join(", ", var.allowed_regions)}"
    }
  }
}
```

Validates BEFORE creation. Stops terraform if condition fails. No resources touched.

Use for: region restrictions, required variable validation, environment constraints.

---

## postcondition

```hcl
resource "aws_s3_bucket" "compliance" {
  bucket = "compliance-bucket"

  tags = {
    Environment = "production"
    Compliance  = "SOC2"
  }

  lifecycle {
    postcondition {
      condition     = contains(keys(self.tags), "Compliance")
      error_message = "Bucket must have a Compliance tag."
    }

    postcondition {
      condition     = contains(keys(self.tags), "Environment")
      error_message = "Bucket must have an Environment tag."
    }
  }
}
```

Validates AFTER creation. Catches issues only visible after resource exists.

Use for: tag compliance, resource state verification, post-creation checks.

---

## Complete Production Pattern

```hcl
resource "aws_db_instance" "production" {
  identifier        = "prod-database"
  engine            = "mysql"
  instance_class    = "db.t3.medium"
  allocated_storage = 20

  lifecycle {
    prevent_destroy       = true
    create_before_destroy = true
    ignore_changes        = [password, snapshot_identifier]

    precondition {
      condition     = var.environment == "production"
      error_message = "This config is for production only."
    }
  }
}
```

---

## Quick Reference

| Rule | When it runs | Purpose |
|---|---|---|
| `create_before_destroy` | During replacement | Zero downtime |
| `prevent_destroy` | During destroy plan | Protect critical resources |
| `ignore_changes` | During plan | Ignore external changes |
| `replace_triggered_by` | When dependency changes | Force replacement |
| `precondition` | Before create/update | Validate inputs |
| `postcondition` | After create/update | Validate state |

---

## Project Structure

```
day09/
├── provider.tf      # AWS provider
├── backend.tf       # Remote state
├── variables.tf     # Input variables
├── main.tf          # All lifecycle examples
├── outputs.tf       # Output values
└── README.md        # This file
```

---

## Key Takeaways

- Every lifecycle rule exists because someone had a production incident
- `prevent_destroy` is non-negotiable for production databases — no exceptions
- `create_before_destroy` reverses Terraform's default destructive-first behaviour
- `ignore_changes` lets Terraform coexist with auto-scaling and external tools
- pre/postconditions are built-in unit tests for your infrastructure

---

## Resources

- [Terraform lifecycle Docs](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
- [Custom Conditions](https://developer.hashicorp.com/terraform/language/expressions/custom-conditions)
- [Full Repo](https://github.com/Ramana175/30DaysOfAWSTerraform)

---

*Day 09 of 30 — [LinkedIn](https://www.linkedin.com/in/venkataramanasanga) · [GitHub](https://github.com/Ramana175/30DaysOfAWSTerraform) · [Blog](https://venkataramana.hashnode.dev)*