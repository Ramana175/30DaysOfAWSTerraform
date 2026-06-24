# 🚀 Day 17 - AWS Elastic Beanstalk Blue-Green Deployment using Terraform

![AWS](https://img.shields.io/badge/AWS-Elastic%20Beanstalk-orange)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple)
![DevOps](https://img.shields.io/badge/DevOps-Blue%20Green%20Deployment-blue)

---

# 📌 Project Overview

This project demonstrates how to implement a Blue-Green Deployment strategy using AWS Elastic Beanstalk and Terraform.

The goal is to deploy two separate environments:

🔵 Blue Environment (Production) → Version 1.0

🟢 Green Environment (Staging) → Version 2.0

Once the Green environment is validated, production traffic can be switched using Elastic Beanstalk CNAME Swapping, enabling near-zero downtime deployments and instant rollback capabilities.

---

# 🎯 Why This Project?

In traditional deployments:

* Downtime may occur
* Rollback takes time
* Production risks are higher

Blue-Green Deployment solves these challenges by maintaining two identical environments and allowing traffic switching between them.

Benefits:

✅ Near Zero Downtime

✅ Instant Rollback

✅ Safe Testing

✅ Reduced Deployment Risk

✅ Production Stability

---

# 🏗️ Architecture

```text
                    Users
                      |
                      v
              Production URL
                      |
                      v
       ┌───────────────────────────┐
       │ Elastic Beanstalk App     │
       └───────────────────────────┘
                 /        \
                /          \
               v            v

     🔵 Blue Environment   🟢 Green Environment
          Version 1.0          Version 2.0

         Production            Staging
```

---

# 🧠 Understanding Blue-Green Deployment (Real-World Example)

When I started this project, I was confused about what actually happens during a Blue-Green deployment.

I initially thought:

```text
Version 2.0 moves into Blue Environment
```

This is NOT how Blue-Green Deployment works.

---

## 🏢 Office Building Example

Imagine a company currently operates from an old office building.

### Old Office

```text
Blue Environment
Version 1.0
```

Employees are currently working here.

---

### New Office

```text
Green Environment
Version 2.0
```

The new office is fully ready.

Before moving employees, everything is tested:

✅ Electricity

✅ Internet

✅ Security

✅ Meeting Rooms

✅ Access Cards

---

## Before Swap

```text
Blue URL
   |
   v

Blue Environment
   |
   v

Version 1.0
```

```text
Green URL
   |
   v

Green Environment
   |
   v

Version 2.0
```

---

## What I Thought

I thought AWS would move:

```text
Version 2.0
↓
Into Blue Environment
```

Wrong.

---

## What Actually Happens

AWS does NOT move:

❌ Code

❌ EC2 Instances

❌ Servers

❌ Environments

AWS only changes where users are sent.

Think of it like changing the office address employees use.

---

## After Swap

Before:

```text
Blue URL
↓
Blue Environment
↓
Version 1.0
```

After:

```text
Blue URL
↓
Green Environment
↓
Version 2.0
```

The environment never changed.

Only traffic routing changed.

This was the biggest learning from this project.

---

# 📂 Project Structure

```text
Day17-blue-green-deployment/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── blue-environment.tf
├── green-environment.tf
├── package-apps.ps1
├── swap-environments.ps1
├── app-v1/
│   └── app-v1.zip
│
├── app-v2/
│   └── app-v2.zip
│
└── README.md
```

---

# 🛠 Technologies Used

* Terraform
* AWS Elastic Beanstalk
* AWS IAM
* AWS S3
* AWS EC2
* Application Load Balancer
* Auto Scaling Groups
* AWS CLI
* PowerShell
* Node.js

---

# 🔐 IAM Resources Explained

## EC2 Role

Purpose:

Allows EC2 instances to access AWS services.

Policies Attached:

* AWSElasticBeanstalkWebTier
* AWSElasticBeanstalkWorkerTier
* AWSElasticBeanstalkMulticontainerDocker

---

## Instance Profile

Purpose:

Connects EC2 instances to IAM Roles.

Without an Instance Profile:

```text
EC2 cannot use IAM permissions.
```

---

## Service Role

Purpose:

Allows Elastic Beanstalk to:

* Manage deployments
* Monitor application health
* Perform updates
* Execute managed actions

Policies:

* AWSElasticBeanstalkEnhancedHealth
* AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy

---

# 📦 S3 Bucket

Purpose:

Stores application artifacts.

Example:

```text
app-v1.zip
app-v2.zip
```

Elastic Beanstalk retrieves application packages from S3 during deployment.

---

# 🔵 Blue Environment

Purpose:

Production Environment

Version:

```text
Version 1.0
```

Environment Variables:

```text
ENVIRONMENT=blue
VERSION=1.0
```

---

# 🟢 Green Environment

Purpose:

Staging Environment

Version:

```text
Version 2.0
```

Environment Variables:

```text
ENVIRONMENT=green
VERSION=2.0
```

---

# 🚀 Deployment Steps

## Step 1: Package Applications

Run:

```powershell
.\package-apps.ps1
```

Verify:

```powershell
ls app-v1
ls app-v2
```

Expected:

```text
app-v1.zip
app-v2.zip
```

---

## Step 2: Initialize Terraform

```bash
terraform init
```

Verify:

```bash
terraform providers
```

---

## Step 3: Validate Configuration

```bash
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

---

## Step 4: Review Infrastructure

```bash
terraform plan
```

Verify:

* IAM Roles
* Instance Profile
* S3 Bucket
* Elastic Beanstalk Application
* Blue Environment
* Green Environment

---

## Step 5: Deploy Infrastructure

```bash
terraform apply
```

Deployment Time:

```text
15-20 Minutes
```

Resources Created:

* EC2 Instances
* Application Load Balancers
* Auto Scaling Groups
* Security Groups
* Elastic Beanstalk Environments
* S3 Bucket

---

## Step 6: Verify Outputs

```bash
terraform output
```

Expected:

```text
blue_environment_url

green_environment_url
```

Open both URLs and verify:

### Blue Environment

```text
Version 1.0
```

### Green Environment

```text
Version 2.0
```

---

# 🔄 Blue-Green Swap

Execute:

```bash
aws elasticbeanstalk swap-environment-cnames \
--source-environment-name my-app-bluegreen-blue \
--destination-environment-name my-app-bluegreen-green \
--region us-east-1
```

Wait:

```text
1-2 Minutes
```

---

## Verify Swap

Before:

```text
Blue URL  → Version 1.0

Green URL → Version 2.0
```

After:

```text
Blue URL  → Version 2.0

Green URL → Version 1.0
```

This confirms that traffic has been redirected successfully.

---

# 🔙 Rollback Procedure

If Version 2 causes issues:

Run:

```bash
aws elasticbeanstalk swap-environment-cnames \
--source-environment-name my-app-bluegreen-green \
--destination-environment-name my-app-bluegreen-blue \
--region us-east-1
```

Result:

```text
Blue URL  → Version 1.0

Green URL → Version 2.0
```

Rollback completes within minutes without redeploying the application.

---

# 🔍 Verification Commands

## Environment Status

```bash
aws elasticbeanstalk describe-environments
```

---

## Environment Events

```bash
aws elasticbeanstalk describe-events
```

---

## Environment Health

```bash
aws elasticbeanstalk describe-environment-health
```

---

## Terraform Outputs

```bash
terraform output
```
# 🐞 Challenges Faced During This Project

This project was not only about writing Terraform code. It also helped me understand how real-world deployments, rollbacks, and troubleshooting work.

---

## Challenge 1: Understanding Blue-Green Deployment

### My Initial Understanding

I thought:

```text id="jqy8j5"
Version 2.0 would move into the Blue Environment
```

After testing and swapping environments multiple times, I learned:

```text id="6mnn24"
The environment never changes.

Only traffic routing changes.
```

### Learning

Elastic Beanstalk uses CNAME swapping to redirect traffic.

---

## Challenge 2: Rollback Verification

### Problem

After rollback, I was still seeing Version 2.

I thought rollback had failed.

### Investigation

Checked events:

```bash id="jlwmrm"
aws elasticbeanstalk describe-events
```

Output showed:

```text id="6lbhd5"
Completed swapping CNAMEs
```

Rollback was successful.

### Root Cause

I was confusing:

```text id="6ps9ez"
Environment Ownership
```

with

```text id="1ob7kv"
URL Ownership
```

### Learning

Always verify:

* CNAME Mapping
* Version Labels
* URL Ownership

---

## Challenge 3: Duplicate Environments

### Problem

I noticed:

```text id="u85t7r"
4 Environments
```

instead of:

```text id="i34jz6"
2 Environments
```

### Investigation

Executed:

```bash id="bx7k2i"
aws elasticbeanstalk describe-environments
```

Checked:

* Environment ID
* Date Created
* Status

Found:

```text id="3vifk5"
Old environments were still present.
```

### Resolution

Terminated obsolete environments.

---

## Challenge 4: Understanding CNAME Swap

Before:

```text id="mh6xlg"
Blue URL -> Version 1.0
Green URL -> Version 2.0
```

After Swap:

```text id="n8vwpz"
Blue URL -> Version 2.0
Green URL -> Version 1.0
```

This was the most important concept I learned.

---

# 🔍 Real-World Troubleshooting Guide

## Problem 1: Environment Health Turns Red

### Symptoms

```text id="jyh4hn"
Health = Red
```

or

```text id="3zhy56"
Health = Severe
```

### Investigation Steps

Step 1

Check Events

```bash id="zvk65q"
aws elasticbeanstalk describe-events
```

---

Step 2

Check Health

```bash id="ydp0im"
aws elasticbeanstalk describe-environment-health
```

---

Step 3

Verify Health Check Path

Example:

```hcl id="o9fsyh"
HealthCheckPath = "/"
```

Wrong path causes health failures.

---

Step 4

Verify Application Port

Elastic Beanstalk:

```hcl id="zj9f0r"
Port = 8080
```

Application:

```javascript id="bbgpgm"
app.listen(3000)
```

Result:

```text id="n5pv7e"
Health = Severe
```

---

Step 5

Review Logs

Elastic Beanstalk Console

```text id="6g7vq3"
Environment
→ Logs
```

---

# Problem 2: Wrong Version Displayed

### Investigation

Check:

```bash id="f48zyr"
aws elasticbeanstalk describe-environments
```

Verify:

* Environment Name
* Version Label
* CNAME

---

### Example

Environment:

```text id="vy3d9u"
Blue Environment -> Version 1.0
```

URL:

```text id="c14z1x"
Blue URL -> Version 2.0
```

This is expected after a swap.

---

# Problem 3: Deployment Failure

### Investigation

Check Events

```bash id="ch7snz"
aws elasticbeanstalk describe-events
```

Check:

* IAM Errors
* Health Check Failures
* Application Startup Errors

---

### Verify IAM

Check:

* Service Role
* Instance Profile
* Trust Relationships

---

# Problem 4: Rollback Completed But Version Didn't Change

### Investigation

Step 1

Open Browser in Incognito Mode

---

Step 2

Check DNS

```bash id="c0y3p9"
nslookup application-url
```

---

Step 3

Verify Events

```bash id="z1cv7y"
aws elasticbeanstalk describe-events
```

---

Step 4

Verify Environment Mapping

```bash id="c53xmr"
aws elasticbeanstalk describe-environments
```

---

# 🎯 Advanced Scenario-Based Interview Questions

## Scenario 1: Production Issue After Deployment

### Question

Version 2.0 was deployed successfully.

Health checks are Green.

Users report application errors after the swap.

What would you do?

---

### Answer

My approach:

Step 1

Determine impact.

Questions:

* Are all users affected?
* Which feature is failing?
* Infrastructure or application issue?

---

Step 2

Verify Environment Health

```bash id="kxz9wq"
aws elasticbeanstalk describe-environment-health
```

---

Step 3

Check Events

```bash id="4vvspx"
aws elasticbeanstalk describe-events
```

---

Step 4

Review Application Logs

---

Step 5

Check Database Connectivity

* Endpoint
* Security Groups
* Credentials

---

Step 6

Rollback if customer impact is high.

```bash id="d3d8sx"
aws elasticbeanstalk swap-environment-cnames
```

### Interview Tip

Always prioritize restoring service before debugging.

---

## Scenario 2: Manager Calls During Production Incident

### Question

Customers cannot login after deployment.

Manager asks:

"What is the current status?"

What will you do?

---

### Answer

Step 1

Rollback immediately.

---

Step 2

Communicate clearly.

Example:

```text id="g8h5v0"
Issue identified after deployment.

Rollback initiated.

Production recovery in progress.
```

---

Step 3

Investigate root cause.

### Interview Tip

Communication is as important as technical troubleshooting.

---

## Scenario 3: Environment Health Severe

### Question

Terraform Apply succeeded.

Environment shows:

```text id="qlm7z2"
Health = Severe
```

What will you check?

---

### Answer

1. Health Check Path
2. Application Port
3. Security Groups
4. Load Balancer
5. Application Logs
6. Environment Events

Most common reason:

Application is not responding on the configured port.

---

## Scenario 4: Blue URL Showing Green Version

### Question

Blue URL is showing Version 2.

Blue Environment still runs Version 1.

Why?

---

### Answer

Blue-Green Deployment uses CNAME swapping.

Blue URL now points to Green Environment.

Environment version never changed.

Traffic routing changed.

---

## Scenario 5: S3 Bucket Deleted

### Question

Application artifact bucket is deleted.

What happens?

---

### Answer

Current application continues working.

However:

❌ New deployments fail

❌ New versions cannot be created

❌ Future rollbacks may fail

---

## Scenario 6: Auto Scaling Not Working

### Question

Traffic increased significantly.

No new EC2 instances launched.

What will you investigate?

---

### Answer

Check:

* Auto Scaling Group
* Scaling Policies
* CloudWatch Alarms
* Instance Limits
* Launch Configurations

---

## Scenario 7: Why Blue-Green Instead of In-Place Deployment?

### Answer

Blue-Green Deployment provides:

✅ Near Zero Downtime

✅ Instant Rollback

✅ Safer Releases

✅ Better Testing

✅ Reduced Risk

This project helped me experience rollback and deployment validation in a real AWS environment.

---

# 👨‍💼 Senior-Level Interview Question

### Question

Explain this project to a hiring manager in 2 minutes.

### Answer

I implemented a Blue-Green Deployment solution using Terraform and AWS Elastic Beanstalk.

Two independent environments were deployed:

* Blue Environment running Version 1.0
* Green Environment running Version 2.0

Application artifacts were stored in Amazon S3. IAM Roles and Instance Profiles were configured for Elastic Beanstalk and EC2 instances. Load Balancers, Auto Scaling Groups, and health monitoring were provisioned automatically through Terraform.

After validating the Green environment, production traffic was switched using Elastic Beanstalk CNAME swapping. I also tested rollback procedures, verified environment mappings, troubleshot duplicate environments, and investigated deployment behavior using AWS CLI commands and Elastic Beanstalk events.

This project helped me understand deployment strategies, rollback mechanisms, infrastructure automation, troubleshooting workflows, and production-grade deployment practices.

---

# 📚 Key Learnings

✅ Blue-Green Deployment

✅ Elastic Beanstalk Architecture

✅ Terraform Automation

✅ IAM Roles & Instance Profiles

✅ S3 Artifact Management

✅ Load Balancers

✅ Auto Scaling

✅ Health Checks

✅ CNAME Swapping

✅ Rollback Strategies

✅ AWS CLI Troubleshooting

✅ Production Incident Handling

---

# 📸 Screenshots to Include

1. Terraform Apply Complete
2. Elastic Beanstalk Application
3. Blue Environment Dashboard
4. Green Environment Dashboard
5. Blue URL Showing Version 1.0
6. Green URL Showing Version 2.0
7. Successful CNAME Swap
8. Rollback Verification
9. Environment Health Status
10. Terraform Outputs

---

# 👨‍💻 Author

**S. Venkata Ramana**

NOC Engineer ➜ DevOps Engineer 🚀

Day 17 of #30DaysOfAWSTerraform

#AWS #Terraform #ElasticBeanstalk #BlueGreenDeployment #DevOps #InfrastructureAsCode
