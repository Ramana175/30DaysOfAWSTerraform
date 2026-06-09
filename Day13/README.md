# Terraform Data Sources - Day 13 Learning Module

## 📖 Overview

A comprehensive guide to mastering **Terraform Data Sources** through hands-on examples. Data sources enable you to reference and query existing infrastructure without managing it—essential for multi-team environments where infrastructure is shared.

**Perfect For:**
- Engineers transitioning from manual infrastructure to IaC
- Teams building on top of shared infrastructure
- Anyone preparing for DevOps/Cloud interviews
- Production deployments requiring dynamic references

---

## 🎯 Learning Objectives

By the end of this module, you will:

✅ Understand the difference between resources and data sources  
✅ Query existing AWS infrastructure using data source filters  
✅ Chain multiple data sources together  
✅ Build dynamic Terraform configurations (no hardcoding IDs)  
✅ Apply production-grade patterns (security groups, AMIs, databases)  
✅ Debug data source queries using `terraform console`  
✅ Design infrastructure contracts between teams  

---

## 📂 Repository Structure

```
terraform-data-sources/
├── README.md                         # This file
├── BLOG_POST.md                      # Deep-dive article
├── DEMO_GUIDE.md                     # Step-by-step walkthrough (optional)
│
├── setup/                            # Pre-existing shared infrastructure
│   ├── main.tf                       # Creates VPC, subnet, security groups
│   ├── outputs.tf                    # Outputs shared resource info
│   └── terraform.tfvars
│
├── code/                             # Main learning examples
│   ├── main.tf                       # EC2 instance using data sources
│   ├── data_sources.tf               # All data source definitions
│   ├── variables.tf                  # Input variables
│   ├── outputs.tf                    # Data source outputs
│   └── terraform.tfvars
│
├── examples/                         # Additional patterns
│   ├── find-latest-ami.tf            # AMI filtering patterns
│   ├── find-security-group.tf        # Security group lookup
│   ├── find-database.tf              # RDS instance discovery
│   └── multi-az-deployment.tf        # Availability zone queries
│
└── patterns/                         # Advanced concepts
    ├── chained-data-sources.tf       # Compose multiple sources
    ├── dynamic-filters.tf            # Variable-based filtering
    └── error-handling.tf             # Graceful failures
```

---

## 🚀 Quick Start (10 minutes)

### Prerequisites

- Terraform v1.0+ (`terraform -v`)
- AWS credentials configured
- Bash shell or PowerShell

### Step 1: Create Shared Infrastructure

First, set up the "shared" VPC that another team provisioned:

```bash
cd setup
terraform init
terraform apply -auto-approve
```

**Output:** VPC, subnet, security group created with predictable tags.

### Step 2: Reference Shared Infrastructure

Now, use data sources to reference what was created:

```bash
cd ../code
terraform init
```

View what will be created:

```bash
terraform plan
```

**Expected:** Will create 1 EC2 instance using data sources to find VPC/subnet/AMI.

```bash
terraform apply -auto-approve
```

### Step 3: Verify in AWS Console

Go to **EC2 → Instances**:
- Find instance named `day13-instance`
- Check **Networking** tab
- Confirm it's in the correct subnet and VPC

### Step 4: Query Data Sources

Test data source queries interactively:

```bash
terraform console

# Try these:
> data.aws_vpc.shared.id
"vpc-12345678"

> data.aws_subnet.primary.cidr_block
"10.0.1.0/24"

> data.aws_ami.linux2.id
"ami-0c55b159cbfafe1f0"

> exit
```

### Step 5: Cleanup

```bash
# Destroy instance (created by code/)
cd /path/to/code
terraform destroy -auto-approve

# Destroy shared infrastructure (created by setup/)
cd ../setup
terraform destroy -auto-approve
```

---

## 📋 Core Concepts Explained

### 1. Resources vs Data Sources

| Aspect | Resource | Data Source |
|--------|----------|-------------|
| **Keyword** | `resource` | `data` |
| **Purpose** | Create infrastructure | Read existing infrastructure |
| **Modifies AWS** | Yes | No |
| **Appears in plan** | Yes (as Create/Update) | No (unless data changes) |
| **Use case** | "I own this resource" | "I reference this resource" |

**Resource example:**
```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

**Data source example:**
```hcl
data "aws_vpc" "shared" {
  tags = { Name = "shared-network-vpc" }
}
```

### 2. Syntax & Reference Pattern

**Define a data source:**
```hcl
data "<TYPE>" "<LOCAL_NAME>" {
  # Arguments (filters, identifiers)
}
```

**Reference its attributes:**
```hcl
data.<TYPE>.<LOCAL_NAME>.<ATTRIBUTE>
```

**Example:**
```hcl
data "aws_vpc" "my_vpc" {
  tags = { Name = "production-vpc" }
}

resource "aws_subnet" "app" {
  vpc_id = data.aws_vpc.my_vpc.id  # Reference the data source
}
```

### 3. Filtering Mechanisms

Data sources accept different filters depending on resource type.

**VPC Filters:**
```hcl
data "aws_vpc" "by_cidr" {
  cidr_block = "10.0.0.0/16"
}

data "aws_vpc" "by_tag" {
  tags = { Environment = "prod", Name = "main-vpc" }
}

data "aws_vpc" "default" {
  default = true
}
```

**Subnet Filters:**
```hcl
data "aws_subnet" "specific" {
  vpc_id = data.aws_vpc.shared.id
  tags = { Name = "app-subnet" }
}

data "aws_subnet" "by_az" {
  vpc_id            = data.aws_vpc.shared.id
  availability_zone = "us-east-1a"
}
```

**AMI Filters:**
```hcl
data "aws_ami" "latest" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]  # Name pattern
  }
  
  filter {
    name   = "state"
    values = ["available"]
  }
  
  owners = ["amazon"]  # Trust Amazon-owned images
}
```

### 4. Chaining Data Sources

Reference one data source within another:

```hcl
# Step 1: Find VPC
data "aws_vpc" "shared" {
  tags = { Name = "shared-vpc" }
}

# Step 2: Find subnet within that VPC
data "aws_subnet" "primary" {
  vpc_id = data.aws_vpc.shared.id  # ← Chain: use VPC's ID
  tags = { Name = "primary-subnet" }
}

# Step 3: Launch instance in that subnet
resource "aws_instance" "app" {
  subnet_id = data.aws_subnet.primary.id  # ← Chain: use subnet's ID
}
```

Flow: VPC → Subnet (in that VPC) → Instance (in that subnet)

---

## 🛠️ Practical Examples

### Example 1: Find Latest AMI

```hcl
data "aws_ami" "ubuntu_latest" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  
  owners = ["099720109477"]  # Canonical (Ubuntu publisher)
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = "t3.micro"
}
```

**Benefit:** Automatically uses the latest patched Ubuntu image without manual updates.

### Example 2: Reference Existing Security Group

```hcl
data "aws_security_group" "web" {
  vpc_id = data.aws_vpc.shared.id
  name   = "web-sg"
}

resource "aws_network_interface" "eni" {
  security_groups = [data.aws_security_group.web.id]
}
```

**Benefit:** App team deploys without managing security group rules (network team owns that).

### Example 3: Get RDS Endpoint

```hcl
data "aws_db_instance" "production" {
  db_instance_identifier = "prod-postgres"
}

output "db_host" {
  value = data.aws_db_instance.production.endpoint
}
```

**Benefit:** Application reads database endpoint from Terraform output, no manual copy-paste.

### Example 4: Multi-AZ Deployment

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "app" {
  count = length(data.aws_availability_zones.available.names)
  
  ami               = data.aws_ami.linux2.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  instance_type     = "t3.micro"
}
```

**Benefit:** Automatically spans all available AZs without hardcoding zone names.

---

## 🔍 Debugging Data Sources

### Method 1: terraform console

```bash
terraform console

# Query data source directly
> data.aws_vpc.shared.id
"vpc-12345678"

> data.aws_subnet.primary.cidr_block
"10.0.1.0/24"

> data.aws_ami.linux2.architecture
"x86_64"

> exit
```

### Method 2: Terraform Output

```hcl
output "vpc_info" {
  value = {
    vpc_id   = data.aws_vpc.shared.id
    cidr     = data.aws_vpc.shared.cidr_block
    state    = data.aws_vpc.shared.state
  }
}
```

```bash
terraform apply
terraform output vpc_info
```

### Method 3: Verbose Plan

```bash
terraform plan -var-file=debug.tfvars -json | jq '.data_sources'
```

### Method 4: Check AWS CLI

Verify data sources match reality:

```bash
# Check VPC
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=shared-network-vpc"

# Check Subnet
aws ec2 describe-subnets --filters "Name=tag:Name,Values=shared-primary-subnet"

# Check AMI
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*" --query "Images[0]"
```

---

## 🎓 Interview Preparation

### Q: "What's the difference between data sources and variables?"

**Answer:**
"Variables are input values you provide. Data sources query your cloud provider in real-time. A variable: `var.vpc_id = 'vpc-12345'` (static, you set it). A data source: `data.aws_vpc.shared.id` (dynamic, queries AWS). Data sources automate; variables require manual input."

### Q: "Are data sources secure?"

**Answer:**
"Yes. Data sources are read-only—they can't create or modify resources. They still require IAM permissions (e.g., `ec2:DescribeVpcs`). But the operation itself is safe. I use them in production."

### Q: "What if a data source doesn't find anything?"

**Answer:**
"Terraform fails during plan with an error like 'no matching VPC found'. This is good—catches configuration errors early. You can handle this gracefully with `try()` or `can()` functions, or use conditional logic with `count`."

### Q: "How do data sources interact with state?"

**Answer:**
"Data sources are recorded in state as references, not as managed resources. They don't create resources in AWS—they only read. They're lightweight. When you run `terraform destroy`, data sources are removed from state but the actual AWS resources they referenced remain untouched."

### Q: "When would you use data sources vs imports?"

**Answer:**
"Data sources: query existing resources for reference (ongoing, dynamic). Imports: bring existing resources under Terraform management (one-time). If you own a resource, import it. If another team owns it and you just reference it, use a data source."

---

## 📚 Best Practices

### 1. Filter Precisely

```hcl
# ❌ Risky (could match multiple)
data "aws_subnet" "app" {
  tags = { Name = "app" }
}

# ✅ Better (specific context)
data "aws_subnet" "app" {
  vpc_id = data.aws_vpc.shared.id
  tags = { Name = "app" }
  availability_zone = "us-east-1a"
}
```

### 2. Specify Owners for AMIs

```hcl
# ❌ Trusts anyone
data "aws_ami" "any" {
  filter { name = "name", values = ["linux*"] }
}

# ✅ Trusted source
data "aws_ami" "safe" {
  filter { name = "name", values = ["amzn2-ami-hvm-*"] }
  owners = ["amazon"]
}
```

### 3. Document Data Source Purpose

```hcl
# Data source: Shared networking VPC
# Owned by: Infrastructure Team
# Tag: shared-network-vpc
# Contact: infra-team@company.com
data "aws_vpc" "shared" {
  tags = { Name = "shared-network-vpc" }
}
```

### 4. Use most_recent for Versioned Resources

```hcl
data "aws_ami" "latest" {
  most_recent = true  # Always pull newest
  filter { name = "name", values = ["amzn2-ami-hvm-*"] }
  owners = ["amazon"]
}
```

### 5. Test Before Using

```bash
terraform console
> data.aws_vpc.shared.id
"vpc-12345"
> exit

# Confirm it's correct before applying
terraform plan
```

---

## 🚨 Common Pitfalls

| Pitfall | Problem | Solution |
|---------|---------|----------|
| **Hardcoding IDs** | Breaks when infrastructure updates | Use data sources to query |
| **Multiple matches** | "Found 2 VPCs matching..." error | Add more specific filters |
| **Wrong owner** | Pulls untrusted/malicious AMI | Specify `owners` (e.g., "amazon") |
| **Forgetting VPC context** | Finds subnet in wrong VPC | Always filter by `vpc_id` first |
| **Not testing** | Discovers data source issues at apply | Use `terraform console` first |

---

## 📊 Progression Path

**Beginner:** Find a VPC by tag  
**Intermediate:** Chain data sources (VPC → Subnet → Instance)  
**Advanced:** Use `count` with data sources for dynamic deployments  
**Expert:** Build module patterns with dynamic data source queries  

---

## 📚 Resources

- [Terraform AWS Data Sources Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources)
- [terraform console command](https://www.terraform.io/cli/commands/console)
- [AWS CLI for verification](https://aws.amazon.com/cli/)
- [Previous lesson: Day 12 - Meta-Arguments](link-to-day-12)
- [Blog post: Data Sources Deep Dive](link-to-blog)

---

## 🤝 Contributing

Found a better example? Have a question? Submit an issue or PR.

```bash
git checkout -b feature/day13-improvement
# Make changes
git commit -m "Day 13: Add example for [specific pattern]"
git push origin feature/day13-improvement
```

---

## 📄 License

MIT License — Use freely in your learning and projects.

---

## 👨‍💻 About This Module

**Royal | NOC Engineer → DevOps Engineer**

Part of the **#30DaysOfAWSTerraform** challenge. Building a public portfolio while mastering Terraform through hands-on examples.

- 🔗 [LinkedIn](https://linkedin.com/in/venkataramanasanga)
- 🐙 [GitHub](https://github.com/royalvenkataram)
- 📝 [Blog](https://venkataramana.hashnode.dev)
- 📍 Bengaluru, India
- 🎯 Open to DevOps, SRE, Cloud, Platform Engineering roles

---

## ❓ FAQ

**Q: Can I use data sources in production?**  
A: Yes. Data sources are safer than hardcoding IDs. Use them extensively in production.

**Q: Do data sources cost money?**  
A: No. Queries are free. But if you create resources using data sources (like EC2), those resources cost money (as with any resource).

**Q: What if the data source filters match nothing?**  
A: Terraform fails during plan with a descriptive error. This is good—catches issues early.

**Q: Can I modify AWS resources through data sources?**  
A: No. Data sources are read-only. To modify, create resources or import existing ones.

**Q: How often are data sources refreshed?**  
A: Each `terraform plan` and `terraform apply` queries AWS in real-time.
