# Day 04 — Terraform State File Management & Remote Backend

> Part of the [#30DaysOfAWSTerraform](https://hashnode.com/n/30daysofawsterraform) challenge by [Piyush Sachdeva](https://www.linkedin.com/in/piyush-sachdeva)

---

## Topics Covered

- How Terraform updates infrastructure using state
- Terraform state file structure and importance
- Remote backend setup with AWS S3
- S3 Native State Locking (Terraform 1.10+ — no DynamoDB required)
- State file best practices and security
- Essential state management commands

---

## How Terraform Uses State

```
Your .tf Code          terraform.tfstate        Real AWS Infrastructure
(desired state)   ←——→  (source of truth)  ←——→  (actual state)
```

Terraform compares your configuration against the state file to determine what needs to be created, updated, or destroyed. Without state, Terraform is blind.

---

## Prerequisites

- Terraform 1.10+ (1.11+ recommended for stable S3 native locking)
- AWS CLI configured (`aws configure`)
- An S3 bucket created **manually** for state storage

> **Important:** Never manage the state bucket as a Terraform resource inside the same config it stores. Create it via CLI or Console.

---

## Step 1 — Create the S3 Backend Bucket

```bash
# Create the bucket
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region us-east-1

# Enable versioning (REQUIRED for native state locking)
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Enable server-side encryption
aws s3api put-bucket-encryption \
  --bucket your-terraform-state-bucket \
  --server-side-encryption-configuration \
  '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
```

Or use the `test.sh` script in this folder for quick setup.

---

## Step 2 — Configure Remote Backend

### `main.tf`

```hcl
terraform {
  backend "s3" {
    bucket       = "your-terraform-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true    # S3 native locking — no DynamoDB needed
    encrypt      = true    # Encrypt state at rest
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

### Backend Parameters

| Parameter | Description |
|---|---|
| `bucket` | S3 bucket name for state storage |
| `key` | Path inside bucket — use `env/terraform.tfstate` pattern |
| `region` | AWS region of the S3 bucket |
| `use_lockfile` | Enables S3 native locking (Terraform 1.10+) |
| `encrypt` | Encrypts state file at rest |

---

## S3 Native State Locking

Starting with **Terraform 1.10**, DynamoDB is no longer needed for state locking.

S3 native locking uses **Conditional Writes** (`If-None-Match` header):

1. Terraform creates a `.tflock` file in S3
2. S3 checks — does this file already exist?
3. If yes → write rejected (412) → another operation is running → blocked
4. If no → lock file created → operation proceeds
5. Operation completes → `.tflock` deleted automatically

> DynamoDB state locking is now **discouraged** and may be deprecated in future Terraform versions.

---

## Terraform Workflow

```bash
# Initialize with remote backend
terraform init

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply

# Verify state is remote
terraform state list

# Clean up
terraform destroy
```

---

## State Management Commands

```bash
# List all resources in state
terraform state list

# Show detailed info for a resource
terraform state show <resource_name>

# Remove resource from state (without destroying)
terraform state rm <resource_name>

# Move resource to different address
terraform state mv <source> <destination>

# Pull and display remote state
terraform state pull

# Force unlock a stuck lock
terraform force-unlock <lock-id>
```

---

## Project Structure

```
day04/
├── main.tf                  # Backend config + resources
├── test.sh                  # Script to create S3 backend bucket via CLI
├── README.md                # This file
└── .terraform.lock.hcl      # Provider version lock
```

---

## Security Best Practices

| Practice | Why |
|---|---|
| Never commit `terraform.tfstate` to Git | Contains sensitive data — account IDs, secrets |
| Enable S3 versioning | Required for locking + enables state rollback |
| Enable encryption | State files contain sensitive resource data |
| Restrict S3 bucket access | Only Terraform runners need access |
| Enable CloudTrail | Audit log of all state file access |
| Separate state per environment | dev/staging/prod should never share state |

---

## Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `Error acquiring the state lock` | Another operation is running | Wait for it to finish or `terraform force-unlock <id>` |
| `StatusCode: 412` | S3 lock file already exists | Normal — means locking is working |
| `Versioning not enabled` | S3 versioning is off | Enable versioning on the bucket |
| `Permission denied` | IAM user lacks S3 permissions | Add `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject` |
| `Bucket not found` | Wrong bucket name or region | Check bucket name and region match |

---

## Key Takeaways

- State file is Terraform's source of truth — never edit it manually
- Local state is dangerous in team environments — always use remote backend
- S3 versioning is **required** for native state locking to work
- `use_lockfile = true` replaces DynamoDB — simpler, cheaper, fewer services
- Use separate state files for each environment
- Requires Terraform 1.10+ for S3 native locking

---

## Resources

- [Terraform S3 Backend Docs](https://developer.hashicorp.com/terraform/language/backend/s3)
- [S3 Native State Locking](https://developer.hashicorp.com/terraform/language/backend/s3#s3-native-state-locking)
- [GitHub: Full Challenge Repo](https://github.com/Ramana175/30DaysOfAWSTerraform)

---

## Next Steps

**Day 05** — Terraform Variables: making your configurations flexible and reusable across environments.

---

*Day 04 of 30 — [Follow the journey on LinkedIn](https://www.linkedin.com/in/venkataramanasanga)*
