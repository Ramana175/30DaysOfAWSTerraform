# Day 14: Static Website Hosting on AWS using Terraform (Mini Project 1)

## Project Overview

In this mini project, we will deploy a fully functional static website on AWS using Terraform.

Instead of hosting a website on a traditional web server, we will use:

* Amazon S3 to store website files
* Amazon CloudFront to deliver content globally
* Terraform to automate the entire infrastructure

This project demonstrates how modern companies host static websites securely, efficiently, and cost-effectively.

Examples:

* Portfolio Websites
* Company Landing Pages
* Documentation Sites
* Product Pages
* Personal Blogs

---

# Real World Story

Imagine you created a simple website consisting of:

* HTML
* CSS
* JavaScript

Normally you would need:

* A server
* Operating system
* Web server software
* Security patches
* Maintenance

Instead AWS allows us to upload files directly to S3.

S3 stores the files.

CloudFront distributes those files from AWS Edge Locations around the world.

When a user visits the website:

User → CloudFront → S3

No server management required.

This makes the architecture:

* Faster
* Cheaper
* More Secure
* Highly Available

---

# Architecture Diagram

```text
                    ┌─────────────────┐
                    │     Internet    │
                    │      Users      │
                    └────────┬────────┘
                             │
                             ▼
                ┌─────────────────────────┐
                │     CloudFront CDN      │
                │  Global Edge Locations  │
                └───────────┬─────────────┘
                            │
                            ▼
                ┌─────────────────────────┐
                │      S3 Bucket          │
                │ Static Website Files    │
                │                         │
                │ index.html              │
                │ style.css               │
                │ script.js               │
                └─────────────────────────┘
```

---

# Traffic Flow Diagram

```text
Step 1

User opens website URL

        │
        ▼

CloudFront receives request

        │
        ▼

CloudFront checks cache

        │
        ├── Cached ?
        │
        ├── YES
        │      │
        │      ▼
        │ Return Content
        │
        └── NO
               │
               ▼

CloudFront requests file from S3

               │
               ▼

S3 returns file

               │
               ▼

CloudFront caches file

               │
               ▼

Content returned to User
```

---

# AWS Resources Used

## 1. S3 Bucket

### Definition

Amazon S3 is an object storage service used to store files.

### Why We Need It

Stores:

* HTML
* CSS
* JavaScript
* Images

without running any server.

---

## 2. S3 Bucket Policy

### Definition

A bucket policy controls who can access objects inside S3.

### Why We Need It

Allows website visitors to read website files.

Without this policy:

Users cannot access website content.

---

## 3. CloudFront Distribution

### Definition

CloudFront is AWS Content Delivery Network (CDN).

### Why We Need It

Benefits:

* Faster website loading
* HTTPS support
* Global caching
* Reduced latency

---

## 4. Terraform

### Definition

Terraform is Infrastructure as Code (IaC).

### Why We Need It

Instead of manually creating AWS resources:

Click → Click → Click

We write code:

```bash
terraform apply
```

and Terraform creates everything automatically.

---

# Project Structure

```text
day14/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
│
└── www/
    ├── index.html
    ├── style.css
    └── script.js
```

---

# Understanding Each Terraform File

## main.tf

Contains:

* S3 Bucket
* Bucket Policy
* CloudFront Distribution
* S3 Object Upload Logic

This is the main infrastructure file.

---

## variables.tf

Contains input variables.

Example:

```hcl
variable "bucket_name" {
  type = string
}
```

Allows reuse of code.

---

## outputs.tf

Displays useful information.

Example:

```bash
terraform output
```

returns:

```bash
website_url
cloudfront_url
bucket_name
```

---

# Prerequisites

Before running this project:

Install:

* AWS CLI
* Terraform
* AWS Account

Verify:

```bash
aws --version

terraform --version
```

---

# Configure AWS CLI

```bash
aws configure
```

Enter:

```text
AWS Access Key ID
AWS Secret Access Key
Region
Output Format
```

Verify:

```bash
aws sts get-caller-identity
```

---

# Deployment Steps

## Step 1

Initialize Terraform

```bash
terraform init
```

---

## Step 2

Validate Configuration

```bash
terraform validate
```

---

## Step 3

Review Resources

```bash
terraform plan
```

---

## Step 4

Deploy Infrastructure

```bash
terraform apply
```

Type:

```bash
yes
```

---

## Step 5

Get Website URL

```bash
terraform output
```

Example:

```bash
https://d123abc.cloudfront.net
```

Open in browser.

---

# How CloudFront Caching Works

First Request:

```text
User → CloudFront → S3
```

Second Request:

```text
User → CloudFront Cache
```

No S3 request required.

This improves:

* Speed
* Performance
* Cost

---

# Cost Optimization

CloudFront reduces:

* S3 requests
* Latency
* Bandwidth costs

This is why production websites use CDN.

---

# Troubleshooting

## Website Not Loading

Check:

```bash
terraform output
```

Verify CloudFront URL.

---

## Access Denied

Check:

* Bucket Policy
* Public Access Configuration

---

## Old Website Still Appearing

CloudFront may be serving cached content.

Create invalidation:

```bash
aws cloudfront create-invalidation \
--distribution-id YOUR_ID \
--paths "/*"
```

---

# Learning Outcomes

After completing this project you will understand:

✅ S3 Static Website Hosting

✅ CloudFront CDN

✅ Terraform Basics

✅ Infrastructure as Code

✅ Website Deployment Automation

✅ CloudFront Caching

✅ AWS Storage Services

---

# Recruiter Style Interview Questions & Answers

## 1. Explain this project as if I am your customer.

### Expected Answer

This project hosts a static website on AWS using Amazon S3 and CloudFront.

The website files (HTML, CSS, and JavaScript) are stored in an S3 bucket. Users do not directly access S3. Instead, requests go through CloudFront, which acts as a global Content Delivery Network (CDN).

CloudFront caches content at AWS Edge Locations worldwide, reducing latency and improving website performance.

Terraform is used to automate the entire infrastructure deployment, making the environment reproducible and easy to manage.

---

## 2. Why did you choose S3 instead of an EC2 instance for hosting the website?

### Expected Answer

Because the website is completely static.

There is no server-side processing or database interaction.

Using EC2 would require:

* Managing operating systems
* Installing web servers
* Security patching
* Monitoring

S3 eliminates these responsibilities and significantly reduces operational overhead and cost.

---

## 3. What problem does CloudFront solve in your architecture?

### Expected Answer

CloudFront improves:

* Performance
* Availability
* Security

Without CloudFront, users would access S3 directly from a single AWS Region.

With CloudFront, content is cached at edge locations closer to users, resulting in lower latency and faster page load times.

---

## 4. Walk me through what happens when a user opens your website.

### Expected Answer

1. User enters the website URL.
2. Request reaches CloudFront.
3. CloudFront checks whether content exists in cache.
4. If cached, CloudFront serves the content immediately.
5. If not cached, CloudFront requests files from S3.
6. S3 returns the content.
7. CloudFront caches the content.
8. User receives the webpage.

---

## 5. Why did you use Terraform for this project?

### Expected Answer

Terraform provides Infrastructure as Code.

Benefits include:

* Automation
* Version Control
* Consistency
* Repeatability

Instead of manually creating AWS resources through the console, everything is defined in code and can be recreated anytime.

---

## 6. What would happen if someone accidentally deleted your infrastructure?

### Expected Answer

Since the infrastructure is defined in Terraform code, it can be recreated using:

```bash
terraform apply
```

This is one of the major advantages of Infrastructure as Code.

---

## 7. How does CloudFront caching reduce AWS costs?

### Expected Answer

CloudFront serves cached content from edge locations.

This reduces:

* Requests to S3
* Data retrieval operations
* Latency

Fewer requests reach the origin, which lowers operational costs.

---

## 8. Why are MIME types important in your project?

### Expected Answer

Browsers need MIME types to correctly interpret files.

Examples:

* text/html → HTML files
* text/css → CSS files
* application/javascript → JavaScript files

Incorrect MIME types can cause browsers to render content incorrectly.

---

## 9. What is the biggest security concern in this architecture?

### Expected Answer

Public access to the S3 bucket.

If permissions are configured incorrectly:

* Sensitive files may become publicly accessible.
* Users may access objects directly.

In production environments, CloudFront Origin Access Control (OAC) should be used to restrict direct S3 access.

---

## 10. If your website content changes, why might users still see old content?

### Expected Answer

Because CloudFront caches files.

Even after updating files in S3, users may continue receiving cached versions until:

* Cache expires
* Cache invalidation is performed

---

## 11. What is cache invalidation?

### Expected Answer

Cache invalidation forces CloudFront to remove cached content and fetch fresh files from the origin.

Example:

```bash
aws cloudfront create-invalidation \
--distribution-id DISTRIBUTION_ID \
--paths "/*"
```

---

## 12. Why is this architecture considered highly available?

### Expected Answer

Amazon S3 provides durable storage and CloudFront distributes content globally.

Even if one edge location experiences issues, CloudFront can serve content from other locations.

---

## 13. If website traffic suddenly increases 100 times, what happens?

### Expected Answer

CloudFront automatically scales.

S3 also automatically scales to handle large request volumes.

No manual server scaling is required.

---

## 14. What are the limitations of this architecture?

### Expected Answer

This architecture supports only static content.

It cannot process:

* User authentication
* Databases
* Server-side code
* APIs

For dynamic applications, services such as EC2, ECS, EKS, or Lambda would be required.

---

## 15. Explain the difference between a static website and a dynamic website.

### Expected Answer

Static Website:

* HTML
* CSS
* JavaScript
* Same content for every user

Dynamic Website:

* Backend code
* Database
* User-specific responses

Examples:

Static → Portfolio Website

Dynamic → Amazon, Netflix, Facebook

---

## 16. Why should organizations prefer Infrastructure as Code?

### Expected Answer

Infrastructure as Code provides:

* Repeatability
* Version Control
* Automation
* Faster Deployments
* Reduced Human Errors

---

## 17. What Terraform files are present in this project and what is their purpose?

### Expected Answer

main.tf

Contains infrastructure resources.

variables.tf

Defines reusable input variables.

outputs.tf

Displays useful information after deployment.

README.md

Project documentation and execution steps.

---

## 18. How would you improve this project for production?

### Expected Answer

I would add:

* Route 53 custom domain
* SSL Certificate using ACM
* CloudFront Origin Access Control (OAC)
* CI/CD Pipeline
* Monitoring and Logging
* WAF for security

---

## 19. What is the difference between CloudFront and S3?

### Expected Answer

S3 stores files.

CloudFront delivers files efficiently to users across the world.

Think of S3 as a warehouse and CloudFront as the delivery network.

---

## 20. Explain your project in one minute as if you are in an interview.

### Expected Answer

I built a static website hosting solution on AWS using Terraform. Website files are stored in Amazon S3 and delivered globally using CloudFront. Terraform automates the provisioning of all AWS resources. This architecture provides scalability, high availability, low operational overhead, and improved performance through edge caching. The project helped me understand Infrastructure as Code, CDN concepts, static website hosting, and AWS storage services.


# Cleanup

Destroy all resources:

```bash
terraform destroy
```

Type:

```bash
yes
```

This removes:

* S3 Bucket
* Bucket Policy
* Website Files
* CloudFront Distribution

and prevents unnecessary AWS charges.

---

# Final Takeaway

This project teaches the foundation of modern static website hosting on AWS.

You learn:

* S3
* CloudFront
* Terraform
* Infrastructure as Code
* CDN Concepts
* Website Deployment

These are real-world skills used by DevOps Engineers and Cloud Engineers in production environments every day.



# Useful Links

## AWS Documentation

- AWS S3 Documentation  
  https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html

- AWS S3 Static Website Hosting  
  https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html

- AWS CloudFront Documentation  
  https://docs.aws.amazon.com/cloudfront/

- AWS CloudFront Developer Guide  
  https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html

- AWS IAM Documentation  
  https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html