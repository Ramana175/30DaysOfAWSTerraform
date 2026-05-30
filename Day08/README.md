# Day 08 — Terraform Meta-Arguments

> Part of the [#30DaysOfAWSTerraform](https://hashnode.com/n/30daysofawsterraform) challenge by [Piyush Sachdeva](https://www.linkedin.com/in/piyush-sachdeva)

---

## Topics Covered

- `count` — numeric iterator for multiple resources
- `for_each` — map/set iterator, stable key-based addressing
- `depends_on` — explicit resource ordering
- `lifecycle` — control creation and destruction behaviour
- `provider` — alternate provider configurations
- `for` expressions in outputs

---

## count

```hcl
# Simple count
resource "aws_s3_bucket" "example" {
  count  = 3
  bucket = "my-bucket-${count.index}"
}
# Creates: my-bucket-0, my-bucket-1, my-bucket-2
# Reference: aws_s3_bucket.example[0]

# Count with list variable
variable "bucket_names" {
  type    = list(string)
  default = ["logs", "backups", "artifacts"]
}

resource "aws_s3_bucket" "from_list" {
  count  = length(var.bucket_names)
  bucket = "${var.bucket_names[count.index]}-bucket"
}
```

⚠ Removing a middle item reindexes everything — may recreate resources.

---

## for_each

```hcl
# With a set
resource "aws_s3_bucket" "env_buckets" {
  for_each = toset(["dev", "staging", "prod"])
  bucket   = "my-bucket-${each.value}"
}
# Reference: aws_s3_bucket.env_buckets["dev"]

# With a map
variable "buckets" {
  type = map(string)
  default = {
    logs      = "us-east-1"
    backups   = "us-west-2"
    artifacts = "eu-west-1"
  }
}

resource "aws_s3_bucket" "regional" {
  for_each = var.buckets
  bucket   = each.key

  tags = {
    Region = each.value
  }
}
# each.key   → bucket name
# each.value → region
```

✅ Remove one item — only that resource is destroyed. Others untouched.

---

## depends_on

```hcl
resource "aws_s3_bucket" "primary" {
  bucket = "my-primary-bucket"
}

resource "aws_s3_bucket" "dependent" {
  bucket = "my-dependent-bucket"

  depends_on = [aws_s3_bucket.primary]
}
```

Use when Terraform cannot detect the dependency automatically.

---

## lifecycle

```hcl
resource "aws_s3_bucket" "critical" {
  bucket = "production-data-bucket"

  lifecycle {
    prevent_destroy       = true      # Block accidental deletion
    create_before_destroy = true      # Zero-downtime replacement
    ignore_changes        = [tags]    # Ignore external tag changes
  }
}
```

| Option | Purpose |
|---|---|
| `prevent_destroy` | Blocks terraform destroy — use on prod databases and critical buckets |
| `create_before_destroy` | Creates replacement before destroying old — zero downtime |
| `ignore_changes` | Ignores drift on specified attributes |

---

## provider

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "aws_s3_bucket" "west_bucket" {
  provider = aws.west
  bucket   = "my-west-bucket"
}
```

Use for multi-region deployments and cross-region replication.

---

## for Expressions in Outputs

```hcl
# List of bucket names
output "bucket_names" {
  value = [for b in aws_s3_bucket.env_buckets : b.bucket]
}

# Map of key to ARN
output "bucket_arns" {
  value = {
    for key, b in aws_s3_bucket.env_buckets : key => b.arn
  }
}

# Splat expression (count-based)
output "all_buckets" {
  value = aws_s3_bucket.example[*].bucket
}
```

---

## count vs for_each

| Feature | count | for_each |
|---|---|---|
| Input | number or list | map or set |
| Addressing | `[0]` `[1]` | `["dev"]` `["prod"]` |
| Stability | less stable | more stable |
| Remove item | may recreate others | only that one |
| Use case | dev/simple | production |

**Rule:** Dev/learning → `count` is fine. Production → always use `for_each`.

---

## Project Structure

```
day08/
├── provider.tf      # AWS provider config
├── backend.tf       # S3 remote state
├── variables.tf     # list, set, map variables
├── local.tf         # common tags + naming
├── main.tf          # count + for_each + lifecycle examples
├── output.tf        # for expressions + splat outputs
└── README.md        # This file
```

---

## Workflow

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
```

---

## Key Takeaways

- Meta-arguments work with **any** resource type — they belong to Terraform not the provider
- `count` simple but unstable — removing middle item reindexes everything
- `for_each` stable — key-based, remove one item, only that one is destroyed
- In a **set**: `each.key` = `each.value`. In a **map**: they are different
- `prevent_destroy = true` is non-negotiable for production critical resources
- Prefer `for_each` over `count` in every production environment

---

## Resources

- [Terraform count](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
- [Terraform for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
- [Terraform lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
- [Full Repo](https://github.com/Ramana175/30DaysOfAWSTerraform)

---

*Day 08 of 30 — [Follow the journey on LinkedIn](https://www.linkedin.com/in/venkataramanasanga)*