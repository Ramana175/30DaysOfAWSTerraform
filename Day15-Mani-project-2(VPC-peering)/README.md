# Day 15 – AWS VPC Peering with Terraform (Mini Project 2)

## Project Overview

This project demonstrates how to create a secure private network connection between two AWS Virtual Private Clouds (VPCs) located in different AWS regions using Terraform.

The goal of this project is to understand how VPC Peering works, how routing is configured, and how AWS networking components interact to enable communication between resources using private IP addresses.

In this project:

* Primary VPC is deployed in **us-east-1**
* Secondary VPC is deployed in **ap-south-1**
* One EC2 instance is launched in each VPC
* VPC Peering is established between the two VPCs
* Route tables are configured for communication
* Security groups allow traffic between VPCs
* Apache Web Server is installed on both EC2 instances
* Terraform state is stored remotely using an S3 Backend

---

# Problem Statement

Imagine a company has:

* Application Servers running in Virginia (us-east-1)
* Database Servers running in Mumbai (ap-south-1)

The company wants these resources to communicate securely using private IP addresses without exposing traffic to the public internet.

AWS VPC Peering solves this problem.

---

# Real World Use Case

Consider an organization with multiple teams:

### Team A

* Application Servers
* Region: us-east-1

### Team B

* Analytics Servers
* Region: ap-south-1

Both teams need private communication.

Instead of exposing applications publicly:

* Create separate VPCs
* Establish VPC Peering
* Communicate privately

Benefits:

* Improved Security
* Reduced Exposure
* Private Communication
* AWS Backbone Network

---

# Architecture Diagram

```text
┌─────────────────────────────────────┐       ┌─────────────────────────────────────┐
│     Primary VPC (us-east-1)         │       │    Secondary VPC (ap-south-1)       │
│     CIDR: 10.0.0.0/16               │       │    CIDR: 10.1.0.0/16                │
│                                     │       │                                     │
│  ┌───────────────────────────────┐  │       │  ┌───────────────────────────────┐  │
│  │  Subnet: 10.0.0.0/16          │  │       │  │  Subnet: 10.1.0.0/16          │  │
│  │                               │  │       │  │                               │  │
│  │  EC2 Instance                 │  │       │  │  EC2 Instance                 │  │
│  │  Apache Installed             │  │       │  │  Apache Installed             │  │
│  │  Private IP                   │  │       │  │  Private IP                   │  │
│  └───────────────────────────────┘  │       │  └───────────────────────────────┘  │
│                                     │       │                                     │
│  Internet Gateway                   │       │  Internet Gateway                   │
└─────────────────┬───────────────────┘       └─────────────────┬───────────────────┘
                  │                                             │
                  └────────────── VPC Peering ─────────────────┘
```

---

# Traffic Flow Diagram

```text
User Laptop
      │
      ▼
SSH (Public IP)
      │
      ▼
Internet Gateway
      │
      ▼
Primary EC2 Instance
      │
      ▼
Route Table
      │
      ▼
VPC Peering Connection
      │
      ▼
Secondary Route Table
      │
      ▼
Secondary EC2 Instance
```

---

# Story-Based Explanation

Imagine two houses.

House A = Primary VPC

House B = Secondary VPC

Initially:

* House A cannot talk to House B
* House B cannot talk to House A

Now imagine building a private road between both houses.

That private road is called:

**VPC Peering**

But building the road alone is not enough.

Both houses need:

* Address
* Roads
* Traffic Rules
* Security Guards

These AWS resources provide those functions.

---

# Resources Used In This Project

## 1. VPC (Virtual Private Cloud)

### Definition

A VPC is a private network inside AWS.

It allows you to launch AWS resources in an isolated network.

### In Our Project

Primary VPC:

```text
10.0.0.0/16
```

Secondary VPC:

```text
10.1.0.0/16
```

### Story

Think of a VPC as a city.

Everything inside the city belongs to you.

No other customer can access it.

---

## 2. Subnet

### Definition

A subnet is a smaller network created inside a VPC.

### In Our Project

Primary Subnet:

```text
10.0.0.0/16
```

Secondary Subnet:

```text
10.1.0.0/16
```

### Story

If VPC is a city,

Subnet is a neighborhood inside that city.

Your EC2 instances live inside neighborhoods.

---

## 3. Internet Gateway

### Definition

An Internet Gateway enables communication between resources inside a VPC and the Internet.

### Why We Need It

Without an Internet Gateway:

* No SSH access
* No Internet
* No package installation

### Story

Think of Internet Gateway as the city exit gate.

Without a gate, nobody can enter or leave the city.

---

## 4. Route Table

### Definition

A Route Table contains rules that tell AWS where traffic should go.

### Example

```text
Destination      Target

0.0.0.0/0        Internet Gateway
10.1.0.0/16      VPC Peering
```

### Story

Think of Route Table as Google Maps.

When traffic arrives:

AWS checks the route table.

Then AWS decides where to send the packet.

---

## 5. Route Table Association

### Definition

Route Table Association connects a subnet to a route table.

### Why Required

Without association:

The subnet does not know which route table to use.

### Story

Imagine assigning traffic rules to a neighborhood.

Without traffic rules:

Cars do not know which road to take.

---

## 6. VPC Peering Connection

### Definition

A VPC Peering Connection creates a private communication channel between two VPCs.

### Important

CIDR blocks must NOT overlap.

Correct:

```text
10.0.0.0/16
10.1.0.0/16
```

Wrong:

```text
10.0.0.0/16
10.0.0.0/16
```

### Story

This is the private highway connecting two cities.

---

## 7. Security Group

### Definition

Security Groups act as virtual firewalls.

### Rules Configured

* SSH (22)
* ICMP (Ping)
* HTTP (80)
* TCP Traffic between VPCs

### Story

Security Groups are security guards.

They decide who can enter the building.

---

## 8. EC2 Instance

### Definition

EC2 is a virtual server in AWS.

### In This Project

* Ubuntu 24.04
* Apache Installed
* Public IP
* Private IP

### Story

EC2 is the actual computer running inside the city.

---

## 9. Terraform Backend (S3)

### Definition

Terraform Backend stores Terraform State remotely.

### Backend Used

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-venkataramana-vpc-peering-demo"
    key    = "lessons/day15/terraform.tfstate"
    region = "us-east-1"
  }
}
```

### Why Use Backend

Benefits:

* Centralized State
* Team Collaboration
* State Recovery
* Safer than local state

---

# Project Structure

```text
.
├── backend.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── data-source.tf
├── locals.tf
├── main.tf
├── outputs.tf
└── README.md
```

## File Explanation

backend.tf

Stores Terraform State in S3.

provider.tf

Configures AWS providers.

variables.tf

Contains reusable variables.

terraform.tfvars

Stores actual values.

data-source.tf

Fetches latest AMI and Availability Zones.

locals.tf

Contains reusable user-data scripts.

main.tf

Creates infrastructure.

outputs.tf

Displays useful information after deployment.

---

## Creating SSH Key Pairs

### us-east-1

```bash
aws ec2 create-key-pair \
--key-name vpc-peering-demo-us-east-1 \
--region us-east-1 \
--query 'KeyMaterial' \
--output text > vpc-peering-demo-us-east-1.pem
```

### ap-south-1

```bash
aws ec2 create-key-pair \
--key-name vpc-peering-demo-ap-south-1 \
--region ap-south-1 \
--query 'KeyMaterial' \
--output text > vpc-peering-demo-ap-south-1.pem
```

---

# How To Run This Project

Initialize Terraform

```bash
terraform init
```

Validate

```bash
terraform validate
```

Create Execution Plan

```bash
terraform plan
```

Deploy Infrastructure

```bash
terraform apply
```

Destroy Infrastructure

```bash
terraform destroy
```

---

# Testing VPC Peering

Get Outputs

```bash
terraform output
```

SSH to Primary

```bash
ssh -i vpc-peering-demo-us-east-1.pem ubuntu@<PRIMARY_PUBLIC_IP>
```

Ping Secondary

```bash
ping <SECONDARY_PRIVATE_IP>
```

Curl Secondary Apache Server

```bash
curl http://<SECONDARY_PRIVATE_IP>
```

If successful:

* Ping replies received
* Apache page displayed

---

# Troubleshooting

### Ping Fails

Check:

* Route Tables
* Security Groups
* VPC Peering Status

### SSH Fails

Check:

* Key Pair
* Internet Gateway
* Public IP
* Security Group

### Curl Fails

Check:

* Apache Service
* Port 80 Rule
* Security Group


# Future Enhancements

* Private Subnets
* NAT Gateway
* VPC Flow Logs
* Load Balancer
* Auto Scaling
* VPN Connection
* Transit Gateway

---

# Learning Outcomes

After completing this project you will understand:

* AWS VPC Fundamentals
* Terraform Basics
* Multi Region Deployments
* VPC Peering
* Route Tables
* Security Groups
* EC2 Provisioning
* Remote State Management
* Infrastructure as Code

---

# Cleanup

```bash
terraform destroy
```

Always destroy resources after testing to avoid AWS charges.



---

# Important Interview Questions

# 🎤 VPC Peering Project Interview Questions & Answers

The following questions are based on this project and are similar to what a DevOps Engineer, Cloud Engineer, or Terraform Engineer may face during interviews.

---

# 1. Explain the VPC Peering project you implemented.

### Answer

In this project, I created two VPCs in different AWS regions using Terraform.

* Primary VPC in us-east-1
* Secondary VPC in ap-south-1

I established a VPC Peering connection between them to enable private communication between resources.

I created:

* VPCs
* Subnets
* Internet Gateways
* Route Tables
* Route Table Associations
* Security Groups
* EC2 Instances

After creating the peering connection, I updated route tables on both sides and configured security groups to allow communication.

Finally, I verified connectivity using ping and curl commands over private IP addresses.

---

# 2. What is VPC Peering?

### Answer

VPC Peering is a networking connection between two VPCs that enables them to communicate using private IP addresses.

Traffic remains on the AWS global network and does not traverse the public internet.

---

# 3. Why did you use VPC Peering in this project?

### Answer

The objective was to enable secure private communication between EC2 instances located in different AWS regions.

Instead of exposing services publicly, VPC Peering allows communication through AWS private infrastructure.

Benefits:

* Improved Security
* Private Communication
* Lower Latency
* No VPN Required

---

# 4. Why must CIDR blocks not overlap?

### Answer

AWS requires non-overlapping CIDR ranges because routing would become ambiguous.

Example:

Correct:

```text
10.0.0.0/16
10.1.0.0/16
```

Incorrect:

```text
10.0.0.0/16
10.0.0.0/16
```

AWS cannot determine which VPC owns the IP range when CIDRs overlap.

---

# 5. What happens after creating a VPC Peering connection?

### Answer

Creating the peering connection alone is not sufficient.

We must:

1. Accept the peering request
2. Update route tables
3. Configure security groups

Without these steps, communication will fail.

---

# 6. Why did you create Route Tables?

### Answer

Route Tables determine where traffic should be sent.

Example:

```text
Destination         Target

0.0.0.0/0           Internet Gateway
10.1.0.0/16         VPC Peering
```

AWS checks the Route Table before forwarding packets.

---

# 7. Why did you associate Route Tables with Subnets?

### Answer

Route Table Association links a subnet to a Route Table.

Without association, the subnet does not know which routing rules to use.

---

# 8. Explain packet flow from Primary EC2 to Secondary EC2.

### Answer

```text
Primary EC2
      ↓
Primary Subnet
      ↓
Primary Route Table
      ↓
VPC Peering Connection
      ↓
Secondary Route Table
      ↓
Secondary Subnet
      ↓
Secondary EC2
```

The Route Table checks the destination CIDR and forwards traffic through the peering connection.

---

# 9. Why did you create Internet Gateways?

### Answer

Internet Gateways provide internet access to resources inside the VPC.

Without an Internet Gateway:

* SSH would fail
* Package installation would fail
* Public internet access would not be possible

---

# 10. What is the purpose of Security Groups?

### Answer

Security Groups act as virtual firewalls.

In this project:

* SSH (22) allowed
* ICMP (Ping) allowed
* TCP traffic between VPCs allowed

They control inbound and outbound traffic.

---

# 11. Why did you allow ICMP traffic?

### Answer

ICMP is required for ping commands.

It was used to validate connectivity between the two EC2 instances through the peering connection.

---

# 12. Why did you use Provider Aliases?

### Answer

Terraform uses provider aliases to manage resources in multiple AWS regions.

Example:

```hcl
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias  = "secondary"
  region = "ap-south-1"
}
```

This allowed me to deploy resources in both regions from the same codebase.

---

# 13. Why did you use Data Sources?

### Answer

Data Sources dynamically fetch information from AWS.

In this project I used:

* Availability Zones
* Latest Ubuntu AMI

This avoids hardcoding values.

---

# 14. Explain the AMI Data Source.

### Answer

Terraform searches AWS and retrieves the latest Ubuntu 24.04 image published by Canonical.

```hcl
most_recent = true
```

ensures the latest available image is selected.

---

# 15. What is Terraform State?

### Answer

Terraform State is a file that stores information about deployed infrastructure.

Examples:

* VPC IDs
* Subnet IDs
* EC2 IDs
* Route Tables
* Peering Connections

Terraform compares the state file with configuration files to determine changes.

---

# 16. Why did you use an S3 Backend?

### Answer

The S3 Backend stores Terraform State remotely.

Benefits:

* Centralized state
* Team collaboration
* Backup and recovery
* Prevents accidental state loss

---

# 17. What troubleshooting steps would you take if Ping fails?

### Answer

I would verify:

1. VPC Peering status
2. Route Table entries
3. Security Group rules
4. Network ACL rules
5. Correct private IP addresses

---

# 18. What troubleshooting steps would you take if Curl fails but Ping works?

### Answer

If ping works but curl fails:

* Check Apache service status
* Verify port 80 is open
* Verify Security Group rules
* Verify web server is running

Commands:

```bash
systemctl status apache2
```

```bash
curl localhost
```

---

# 19. What is the biggest limitation of VPC Peering?

### Answer

VPC Peering is not transitive.

Example:

```text
VPC-A <--> VPC-B
VPC-B <--> VPC-C
```

VPC-A cannot communicate with VPC-C unless another direct peering connection exists.

---

# 20. If your organization has 100 VPCs, would you use VPC Peering?

### Answer

No.

Managing VPC Peering at that scale becomes complex.

For large environments I would use AWS Transit Gateway.

Benefits:

* Centralized connectivity
* Transitive routing
* Easier management
* Scalable architecture

---

# ⭐ Bonus Question

## Draw your architecture and explain traffic flow.

### Answer

```text
User Laptop
      │
      ▼
Internet Gateway
      │
      ▼
Primary EC2
      │
      ▼
Route Table
      │
      ▼
VPC Peering
      │
      ▼
Secondary Route Table
      │
      ▼
Secondary EC2
```

Traffic Flow:

1. User connects to Primary EC2.
2. EC2 sends traffic to destination 10.1.0.0/16.
3. Route Table checks destination.
4. Route points to VPC Peering.
5. Traffic moves through AWS Backbone.
6. Secondary Route Table receives traffic.
7. Security Group validates traffic.
8. Secondary EC2 responds.

This demonstrates successful private communication between two VPCs across AWS regions.


# Terraform Interview Questions & Answers (Project-Based)

These questions are commonly asked during DevOps, Cloud Engineer, Platform Engineer, and Terraform interviews. The answers are based on this VPC Peering project implementation.

---

## 21. What is Terraform?

### Answer

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp.

Instead of manually creating resources in AWS Console, we define infrastructure in code and Terraform creates, updates, and destroys resources automatically.

### Benefits

* Infrastructure Automation
* Consistency
* Reusability
* Version Control
* Reduced Human Errors

### Example from this Project

Using Terraform, I created:

* VPCs
* Subnets
* Internet Gateways
* Route Tables
* Security Groups
* EC2 Instances
* VPC Peering Connection

all from code without manually creating resources in AWS Console.

---

## 22. Why did you choose Terraform for this VPC Peering project?

### Answer

Terraform allowed me to automate the complete infrastructure deployment.

Instead of manually creating networking resources in two different AWS regions, Terraform provisioned everything through code.

### Advantages

* Faster deployments
* Repeatable deployments
* Easy maintenance
* Infrastructure versioning
* Team collaboration

---

## 23. What is a Provider in Terraform?

### Answer

A Provider is a plugin that allows Terraform to communicate with cloud platforms such as AWS, Azure, or GCP.

In this project, AWS Provider was used.

Example:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Terraform uses the AWS provider to create AWS resources.

---

## 24. Why did you use Provider Aliases?

### Answer

This project creates resources in two AWS regions:

* us-east-1
* ap-south-1

Terraform needs separate provider configurations for each region.

Example:

```hcl
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias  = "secondary"
  region = "ap-south-1"
}
```

Resource Example:

```hcl
resource "aws_vpc" "primary" {
  provider = aws.primary
}
```

This tells Terraform where to create the resource.

---

## 25. What is variables.tf?

### Answer

variables.tf is used to declare variables.

Example:

```hcl
variable "primary_region" {
  type = string
}
```

The variable acts like a placeholder.

Terraform expects the actual value to be supplied later.

### Why use variables?

* Reusable code
* Environment flexibility
* Easy maintenance

---

## 26. What is terraform.tfvars?

### Answer

terraform.tfvars contains actual values for variables declared in variables.tf.

Example:

```hcl
primary_region = "us-east-1"

secondary_region = "ap-south-1"

primary_vpc_cidr = "10.0.0.0/16"

secondary_vpc_cidr = "10.1.0.0/16"
```

Think of it like this:

### variables.tf

Asks:

```text
What is your primary region?
```

### terraform.tfvars

Answers:

```text
us-east-1
```

---

## 27. Difference Between variables.tf and terraform.tfvars

| variables.tf       | terraform.tfvars           |
| ------------------ | -------------------------- |
| Defines variables  | Assigns values             |
| Defines type       | Provides actual data       |
| Structure          | Configuration              |
| Used by developers | Used by users/environments |

Example:

### variables.tf

```hcl
variable "primary_region" {}
```

### terraform.tfvars

```hcl
primary_region = "us-east-1"
```

---

## 28. What is backend.tf?

### Answer

backend.tf defines where Terraform State should be stored.

In this project:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-venkataramana-vpc-peering-demo"
    key    = "lessons/day15/terraform.tfstate"
    region = "us-east-1"
  }
}
```

Instead of storing state locally, it is stored in Amazon S3.

---

## 29. Why did you use S3 Backend?

### Answer

Terraform State is extremely important.

If the local machine crashes, the state file may be lost.

Storing state in S3 provides:

* Centralized storage
* Team collaboration
* Backup
* High availability
* Disaster recovery

---

## 30. What is Terraform State File?

### Answer

Terraform State File keeps track of all resources managed by Terraform.

Example:

```text
terraform.tfstate
```

Stores:

* VPC IDs
* Subnet IDs
* Route Table IDs
* Security Group IDs
* EC2 Instance IDs
* Peering Connection IDs

Terraform compares:

```text
Terraform Code
      VS
Terraform State
```

to determine changes.

---

## 31. What are Data Sources?

### Answer

Data Sources allow Terraform to read existing information from AWS.

Example from this project:

```hcl
data "aws_ami" "primary_ami"
```

This fetches the latest Ubuntu AMI.

Another example:

```hcl
data "aws_availability_zones" "primary"
```

This retrieves available Availability Zones dynamically.

### Benefits

* Avoid hardcoding
* Dynamic configuration
* More reusable code

---

## 32. Why did you use aws_ami Data Source?

### Answer

AMI IDs change frequently.

Instead of hardcoding an AMI ID, Terraform automatically finds the latest Ubuntu image.

Example:

```hcl
most_recent = true
```

This ensures the latest Ubuntu image is selected during deployment.

---

## 33. What is locals.tf?

### Answer

locals.tf stores reusable values.

Example from this project:

```hcl
locals {
  primary_user_data = <<EOF
  ...
EOF
}
```

Benefits:

* Avoid code duplication
* Easier maintenance
* Cleaner code

---

## 34. What is output.tf?

### Answer

Outputs display useful information after deployment.

Example:

```hcl
output "primary_instance_public_ip" {
  value = aws_instance.primary_instance.public_ip
}
```

After Terraform Apply:

```bash
terraform output
```

Terraform displays:

* Instance IPs
* VPC IDs
* CIDR blocks
* Peering Connection ID

---

## 35. What happens when you run terraform init?

### Answer

Command:

```bash
terraform init
```

Terraform:

1. Downloads providers
2. Initializes backend
3. Creates .terraform directory
4. Prepares working directory

This is the first command executed in every Terraform project.

---

## 36. What happens when you run terraform plan?

### Answer

Command:

```bash
terraform plan
```

Terraform compares:

```text
Terraform Configuration
          VS
Terraform State
```

and shows:

```text
+ Create
~ Modify
- Destroy
```

No infrastructure changes occur at this stage.

---

## 37. What happens when you run terraform apply?

### Answer

Command:

```bash
terraform apply
```

Terraform provisions infrastructure.

Example from this project:

* Creates VPCs
* Creates Subnets
* Creates Route Tables
* Creates Security Groups
* Creates EC2 Instances
* Creates VPC Peering

Infrastructure becomes available in AWS.

---

## 38. What happens when you run terraform destroy?

### Answer

Command:

```bash
terraform destroy
```

Terraform removes all resources created by the configuration.

Resources deleted:

* EC2 Instances
* Security Groups
* Route Tables
* Internet Gateways
* VPC Peering Connection
* Subnets
* VPCs

This prevents unnecessary AWS charges.

---

## 39. Explain your Terraform project structure.

### Answer

```text
project/
│
├── backend.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── data-source.tf
├── locals.tf
├── main.tf
├── output.tf
└── README.md
```

### Purpose

backend.tf
→ Stores Terraform State remotely

provider.tf
→ AWS Provider Configuration

variables.tf
→ Variable Declarations

terraform.tfvars
→ Variable Values

data-source.tf
→ Fetch Existing AWS Information

locals.tf
→ Reusable Local Variables

main.tf
→ Infrastructure Resources

output.tf
→ Display Outputs

README.md
→ Project Documentation

---

## 40. Explain this project from start to finish.

### Answer

I created a multi-region VPC Peering infrastructure using Terraform.

Steps:

1. Configured AWS providers for us-east-1 and ap-south-1.
2. Created two VPCs with non-overlapping CIDRs.
3. Created public subnets in both VPCs.
4. Attached Internet Gateways.
5. Created Route Tables.
6. Associated Route Tables with Subnets.
7. Created VPC Peering Connection.
8. Accepted the Peering Request.
9. Added routes for cross-VPC communication.
10. Configured Security Groups.
11. Launched Ubuntu EC2 Instances.
12. Installed Apache using User Data.
13. Verified communication using ping and curl.
14. Stored Terraform State in S3 Backend.

Result:

Both EC2 instances successfully communicated using private IP addresses across AWS regions through VPC Peering.

---
