# Day 03 — S3 Bucket with Terraform

> Part of the [#30DaysOfAWSTerraform](https://hashnode.com/n/30daysofawsterraform) challenge by [Piyush Sachdeva](https://www.linkedin.com/in/piyush-sachdeva)

---

## Topics Covered

- AWS Authentication & Authorization
- S3 Bucket creation and management with Terraform
- Terraform workflow: `init` → `validate` → `plan` → `apply` → `destroy`

---

## Prerequisites

### 1. AWS Account
Sign up for the [AWS Free Tier](https://aws.amazon.com/free/) if you don't have an account.

### 2. Install AWS CLI

Check your system architecture first:
```bash
# Linux/macOS
uname -m

# Windows PowerShell
$env:PROCESSOR_ARCHITECTURE
```

**Windows:**
```powershell
# Using winget (recommended)
winget install Amazon.AWSCLI

# Using Chocolatey
choco install awscli
```

**macOS:**
```bash
# Using Homebrew
brew install awscli

# Using official installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

**Ubuntu/Debian (x86_64):**
```bash
sudo apt update
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

**Ubuntu/Debian (ARM64):**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

---

## AWS Authentication

### Method 1: AWS CLI Configuration (Recommended)
```bash
aws configure
```
You'll be prompted for:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., `us-east-1`)
- Default output format (`json`)

### Method 2: Environment Variables
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Method 3: IAM Roles
Best practice for EC2 instances or AWS services — attach an IAM role directly, no keys needed.

### Method 4: Named AWS Profiles
```bash
aws configure --profile dev
export AWS_PROFILE=dev
```

---

## Terraform Configuration

### Provider Setup (`main.tf`)
```hcl
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

### S3 Bucket Resource
```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "your-unique-bucket-name-day03"   # Must be globally unique

  tags = {
    Name        = "Day03-S3-Bucket"
    Environment = "Learning"
    Challenge   = "30DaysOfAWSTerraform"
  }
}
```

> **Note:** S3 bucket names must be **globally unique** across all AWS accounts worldwide.

---

## Terraform Workflow

```bash
# 1. Initialize — download provider plugins
terraform init

# 2. Validate — check config syntax
terraform validate

# 3. Plan — preview what will be created
terraform plan

# 4. Apply — create the S3 bucket
terraform apply

# 5. Verify — check current state
terraform show

# 6. Destroy — clean up resources (saves AWS costs)
terraform destroy
```

---

## Project Structure

```
day03/
├── main.tf        # Provider + S3 bucket resource
├── README.md      # This file
└── .terraform.lock.hcl  # Provider version lock (committed to Git)
```

---

## Key Learnings

- AWS credentials must be configured before Terraform can call AWS APIs
- IAM Roles are the most secure authentication method — no static keys stored anywhere
- S3 bucket names are globally unique — across every AWS account in every region
- `terraform validate` catches syntax errors before you even talk to AWS
- Always run `terraform destroy` after practice to avoid unexpected AWS charges

---

## Important Notes

| Topic | Detail |
|---|---|
| Bucket naming | Lowercase, 3–63 chars, globally unique, no underscores |
| Region | Ensure region matches your intended deployment |
| Free Tier | S3 gives 5 GB storage, 20,000 GET, 2,000 PUT requests/month free |
| Cleanup | Always `terraform destroy` when done — storage costs accumulate |
| Credentials | Never commit `~/.aws/credentials` or hardcode keys in `.tf` files |

---

## Troubleshooting

**`Error: No valid credential sources found`**
→ Run `aws configure` or export environment variables

**`BucketAlreadyExists`**
→ S3 bucket names are global — choose a more unique name

**`Error: Invalid region`**
→ Check your `provider "aws" { region = "..." }` block

**`AccessDenied`**
→ Your IAM user/role needs `s3:CreateBucket` permission

---

## Resources

- [Terraform AWS S3 Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [AWS CLI Installation](https://aws.amazon.com/cli/)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [S3 Bucket Naming Rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)

---

## Next Steps

**Day 04** — Terraform State File Management: remote backends using S3 + DynamoDB for state locking.

---

*Day 03 of 30 — Building in public. [Follow the journey on LinkedIn](https://www.linkedin.com/in/venkataramanasanga)*