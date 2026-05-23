# Day 01 — Why Terraform Exists (Infrastructure as Code Basics)

## 📌 Topic
Introduction to Infrastructure as Code (IaC) and Terraform fundamentals.

---

## 🧠 What I Learned

Before Terraform, infrastructure was built by manually clicking through the AWS console.
This caused **infrastructure drift** — environments diverge silently and nobody knows why.

As a NOC Engineer, I've seen this cause real incidents at 2 AM.
The question that always takes longest: **"What changed?"**

Terraform answers that question automatically — everything is in Git.

---

## ❌ Problem — Manual Setup

| Issue | Impact |
|---|---|
| Engineer A builds Dev → t2.micro | Different from Prod |
| Engineer B builds Prod → t2.medium | Config drift |
| No record of changes | Can't debug incidents |
| "Works on my machine" | Environment inconsistency |

---

## ✅ Solution — Terraform (IaC)

- One `.tf` file defines everything
- Same code → Dev, Staging, Prod
- Git history = full audit trail
- Identical environments, always

---

## ⚙️ The 4-Command Workflow

```bash
terraform init      # Download provider plugins (like npm install)
terraform plan      # Preview changes — dry run, nothing created
terraform apply     # Build real infrastructure via AWS APIs
terraform destroy   # Tear it all down cleanly — saves money
```

---

## 📄 My First Terraform Resource

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Mumbai — closest to Bengaluru
}

resource "aws_instance" "web_server" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"

  tags = {
    Name        = "day01-demo"
    Environment = "learning"
    ManagedBy   = "terraform"
    Challenge   = "30DaysOfAWSTerraform"
    Day         = "01"
  }
}
```

---

## 🌍 Why Terraform Over CloudFormation?

| Tool | Multi-cloud | Language |
|---|---|---|
| **Terraform** | ✅ All clouds | HCL (readable) |
| CloudFormation | ❌ AWS only | JSON/YAML |
| ARM Templates | ❌ Azure only | JSON (verbose) |

---

## 💡 Key Takeaways

- Infrastructure drift is a real production problem — Terraform prevents it by design
- `terraform plan` = built-in change advisory — preview before you break anything
- Terraform is cloud-agnostic — AWS, Azure, GCP, Kubernetes, and more
- IaC means infrastructure is in Git — auditable, reviewable, rollback-able
- `terraform destroy` is your wallet's best friend when learning

---

## 🔗 Resources

- 📝 [Blog Post](https://venkataramana.hashnode.dev/day-01-why-terraform-exists-and-why-it-finally-clicked-for-me-as-a-noc-engineer)
- 💼 [LinkedIn Post](https://www.linkedin.com/posts/venkataramanasanga_30daysofawsterraform-30daysofawsterraform-share-7463943702303043584-FErB/)
- 🎥 [Day 01 Video — Piyush Sachdeva](https://youtu.be/s5fwSG_00P8?si=3f1GqPNeI8BLNw4L)

---

*Part of the [#30DaysOfAWSTerraform](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws) challenge by Piyush Sachdeva*
