# Terraform Provisioners Demo 🚀

> Learn how Terraform Provisioners work by creating an AWS EC2 instance and executing commands locally, remotely, and by transferring files. This project demonstrates **local-exec**, **remote-exec**, and **file provisioners**, along with their real-world use cases, limitations, and best practices.

---

## 📌 Project Overview

Infrastructure as Code (IaC) is designed to provision infrastructure declaratively. However, there are situations where we need to execute commands after a resource is created.

Terraform provides **Provisioners** for these scenarios.

In this project, I created an EC2 instance using Terraform and demonstrated the three most commonly used provisioners:

* **local-exec**
* **remote-exec**
* **file**

Each provisioner solves a different problem, and understanding when (and when not) to use them is an important DevOps skill.

---

# 🏗️ Architecture

```
                Terraform
                     │
                     │
              terraform apply
                     │
                     ▼
          AWS EC2 Instance Created
                     │
     ┌───────────────┼────────────────┐
     │               │                │
     ▼               ▼                ▼
local-exec      remote-exec      file provisioner
(Local PC)       (EC2 SSH)      (Copy Files)
```

---

# 📂 Project Structure

```
Terraform-Provisioners-Demo
│
├── backend.tf
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
│
├── scripts
│     └── welcome.sh
│
├── demo.sh
│
└── README.md
```

---

# 🚀 What are Terraform Provisioners?

Provisioners are special blocks in Terraform that execute scripts or commands during the lifecycle of a resource.

Unlike normal Terraform resources, provisioners perform procedural tasks.

For example:

* Install software
* Configure servers
* Copy files
* Execute shell scripts
* Register servers
* Trigger external APIs

Provisioners execute **only during creation or destruction** of a resource.

Terraform itself recommends using them **only when there is no better alternative**.

---

# Why Provisioners Exist

Terraform creates infrastructure.

Sometimes infrastructure alone isn't enough.

Imagine Terraform creates an EC2 instance.

After the instance starts, you may want to:

* Install Nginx
* Install Docker
* Copy configuration files
* Execute scripts
* Register the server with another system

Provisioners help automate these tasks.

---

# Provisioners Demonstrated

## 1️⃣ local-exec Provisioner

### Where does it run?

On the machine running Terraform.

This could be:

* Your laptop
* GitHub Actions Runner
* Jenkins
* GitLab Runner

### Example

```hcl
provisioner "local-exec" {
  command = "echo ${self.public_ip}"
}
```

### Common Use Cases

* Update inventory files
* Trigger API calls
* Execute local scripts
* Send Slack notifications
* Call Jenkins jobs

### Advantages

* No SSH required
* Easy to use
* Runs instantly

### Limitations

* Cannot configure remote servers
* Only runs where Terraform executes

---

# 2️⃣ remote-exec Provisioner

### Where does it run?

Inside the EC2 instance over SSH.

Terraform connects to the server using:

* SSH
* Private Key
* Username

Example:

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install nginx -y"
  ]
}
```

### Connection Block

```hcl
connection {
  type        = "ssh"
  user        = "ubuntu"
  private_key = file(var.private_key_path)
  host        = self.public_ip
}
```

### Common Use Cases

* Install packages
* Start services
* Configure Linux
* Create users
* Execute shell commands

### Advantages

* Easy server bootstrap
* Simple automation

### Limitations

Requires:

* SSH
* Security Group
* Public IP (or VPN/Bastion)
* Working private key

---

# 3️⃣ File Provisioner

The File Provisioner copies files from your local machine to the remote EC2 instance.

Example:

```hcl
provisioner "file" {
  source      = "scripts/welcome.sh"
  destination = "/tmp/welcome.sh"
}
```

Usually followed by:

```hcl
provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/welcome.sh",
    "/tmp/welcome.sh"
  ]
}
```

### Common Use Cases

* Upload scripts
* Copy SSL certificates
* Transfer application files
* Deploy configuration files

---

# Provisioner Execution Flow

```
terraform apply

↓

EC2 Created

↓

local-exec (Local Machine)

↓

SSH Connection

↓

remote-exec Commands

↓

Copy Files

↓

Execute Files
```

---

# Demo Walkthrough

### Step 1

Initialize Terraform

```bash
terraform init
```

---

### Step 2

Review the execution plan

```bash
terraform plan
```

---

### Step 3

Deploy the infrastructure

```bash
terraform apply \
-var="key_name=my-key" \
-var="private_key_path=./my-key.pem"
```

Terraform will:

* Create Security Group
* Launch EC2 Instance
* Execute Provisioner

---

### Step 4

Verify

SSH into the instance

```bash
ssh -i my-key.pem ubuntu@<public-ip>
```

Verify:

```
/tmp/remote_exec.txt
```

or

```
/tmp/welcome.sh
```

depending on the provisioner used.

---

# Re-running a Provisioner

Provisioners **do not execute on every `terraform apply`**.

They only run when the resource is created.

To execute them again:

```bash
terraform taint aws_instance.demo
```

or

```bash
terraform apply \
-replace=aws_instance.demo
```

Terraform recreates the instance and executes the provisioners again.

---

# Destroy-Time Provisioners

Provisioners can also run during resource deletion.

Example:

```hcl
provisioner "local-exec" {
  when    = destroy
  command = "echo Instance Deleted"
}
```

Useful for:

* Notifications
* Cleanup
* Deregistration
* Removing DNS records

---

# Best Practices

✅ Prefer `user_data` or `cloud-init` for EC2 initialization.

✅ Keep provisioners simple and idempotent.

✅ Restrict SSH access to trusted IPs.

✅ Use `on_failure = continue` only when appropriate.

✅ Never commit private keys (`*.pem`) to version control.

---

# When Should You Avoid Provisioners?

Provisioners are powerful but should be the **last option**, not the first.

Prefer these alternatives:

| Requirement                | Better Option          |
| -------------------------- | ---------------------- |
| Install packages on EC2    | user_data / cloud-init |
| Create AMIs                | Packer                 |
| Configure multiple servers | Ansible                |
| Post-deployment management | AWS Systems Manager    |
| Application deployment     | Docker / Kubernetes    |

---

# Key Learnings

* Learned how Terraform executes provisioners during resource creation.
* Understood the difference between local-exec, remote-exec, and file provisioners.
* Configured SSH connections for remote execution.
* Learned how to transfer files and execute them on EC2.
* Explored provisioner limitations and why HashiCorp recommends alternatives for production.

---

# Common Errors

### SSH Timeout

Usually caused by:

* Wrong Security Group
* Wrong Username
* Private Subnet
* Incorrect Key Pair

---

### Invalid Private Key

Ensure the correct PEM file is used:

```bash
private_key = file(var.private_key_path)
```

---

### Permission Denied

Fix permissions:

```bash
chmod 400 my-key.pem
```

---

# Interview Questions & Answers

### Q1. What is a Terraform Provisioner?

A Provisioner is used to execute scripts or commands on the local machine or remote resource after infrastructure creation or during destruction.

---

### Q2. What are the different types of Provisioners?

* local-exec
* remote-exec
* file

---

### Q3. Why are Provisioners considered a last resort?

Terraform is declarative, while provisioners are imperative. Native cloud features like `user_data`, `cloud-init`, or configuration management tools are more reliable, repeatable, and easier to maintain.

---

### Q4. When do Provisioners execute?

Only during:

* Resource creation
* Resource destruction (if `when = destroy` is used)

They do **not** run on every `terraform apply`.

---

### Q5. How can you re-run a Provisioner?

Recreate the resource:

```bash
terraform taint aws_instance.demo
```

or

```bash
terraform apply -replace=aws_instance.demo
```

---

### Q6. What is the difference between local-exec and remote-exec?

| local-exec             | remote-exec                   |
| ---------------------- | ----------------------------- |
| Runs on local machine  | Runs on remote EC2            |
| No SSH required        | SSH required                  |
| Good for orchestration | Good for server configuration |

---

### Q7. Can Provisioners copy files?

Yes. The `file` provisioner copies files from the local machine to the remote server.

---

### Q8. What is the recommended alternative to Provisioners?

* EC2 `user_data`
* `cloud-init`
* Packer
* Ansible
* AWS Systems Manager

---

# How to Explain This Project in an Interview

> "In this project, I explored Terraform Provisioners by provisioning an AWS EC2 instance and demonstrating all three major provisioner types: local-exec, remote-exec, and file. I learned how local-exec runs commands on the machine executing Terraform, while remote-exec connects to the EC2 instance over SSH to perform configuration tasks. I also used the file provisioner to transfer scripts to the server and execute them remotely. Through this project, I understood that provisioners are useful for bootstrapping but should be used sparingly because Terraform recommends native solutions like user_data, cloud-init, or configuration management tools for production environments."

---

# Tech Stack

* Terraform
* AWS EC2
* AWS Security Groups
* SSH
* Ubuntu 22.04
* Bash
* Infrastructure as Code (IaC)

---

# Conclusion

This project provided hands-on experience with Terraform Provisioners and clarified their role in Infrastructure as Code workflows. While they are useful for demonstrations, bootstrapping, and simple automation, production environments should rely on cloud-native initialization mechanisms or dedicated configuration management tools. Understanding when to use provisioners—and when to avoid them—is an important skill for any DevOps Engineer.
