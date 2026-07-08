# 🚀 Serverless Image Processing Pipeline using AWS Lambda, S3 & Terraform

## 📖 About the Project

This project is a serverless image processing application that automatically processes images uploaded to Amazon S3.

Whenever a new image is uploaded, Amazon S3 triggers an AWS Lambda function. The Lambda function uses the Pillow Python library to generate multiple optimized versions of the image, such as compressed JPEGs, WebP, PNG, and a thumbnail. These processed images are then stored in a separate S3 bucket.

I built this project to gain hands-on experience with AWS serverless services and Infrastructure as Code (Terraform). Instead of manually creating AWS resources through the AWS Console, the complete infrastructure is deployed using Terraform, making the setup repeatable and easy to manage.

This project also helped me understand how different AWS services communicate with each other in an event-driven architecture.

---

## 🎯 Project Goal

The main goal of this project is to automate image processing using AWS services.

When a user uploads an image, the application automatically:

- Detects the upload
- Triggers a Lambda function
- Processes the image
- Creates multiple optimized versions
- Stores the processed images in another S3 bucket

Everything happens automatically without any manual intervention.

---

## ✨ Features

- Serverless architecture
- Automatic image processing
- Event-driven workflow
- Multiple image formats (JPEG, PNG, WebP)
- Thumbnail generation
- Infrastructure as Code using Terraform
- Docker-based Lambda Layer
- CloudWatch logging
- Secure IAM permissions
- Private S3 buckets
- Server-side encryption
- Bucket versioning
- Automated deployment scripts

---

## 🛠️ Technologies Used

- AWS Lambda
- Amazon S3
- IAM
- CloudWatch
- Terraform
- Python 3.12
- Pillow
- Docker
- Bash

---

## 🏗️ Architecture

```text
                Upload Image
                     │
                     ▼
          Amazon S3 Upload Bucket
                     │
        S3 ObjectCreated Notification
                     │
                     ▼
            AWS Lambda Function
            (Python + Pillow)
                     │
      ┌──────────────┼──────────────┐
      │              │              │
      ▼              ▼              ▼
Compressed JPG     WebP           PNG
      │
      ▼
 Thumbnail
      │
      ▼
 Amazon S3 Processed Bucket
```

---

## 📂 Project Structure

```text
Day18-mini-project-aws-lambda

├── lambda/
│   ├── lambda_function.py
│   └── requirements.txt
│
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
│
├── scripts/
│   ├── build_layer_docker.sh
│   ├── deploy.sh
│   └── destroy.sh
│
└── README.md
```# ⚙️ How the Application Works

The application follows a simple event-driven workflow.

### Step 1 – Upload an Image

The process starts when a user uploads an image to the upload S3 bucket.

Example:

```bash
aws s3 cp photo.jpg s3://image-processor-upload-bucket/
```

---

### Step 2 – S3 Triggers Lambda

Amazon S3 is configured with an ObjectCreated event notification.

Whenever a new file is uploaded, S3 automatically invokes the Lambda function.

No manual execution is required.

---

### Step 3 – Lambda Downloads the Image

The Lambda function receives the event, identifies the uploaded object, and downloads it from S3.

```python
response = s3_client.get_object(
    Bucket=bucket,
    Key=key
)
```

---

### Step 4 – Image Processing

The Pillow library opens the image and performs several operations.

The application:

- Reads the original image
- Converts it to RGB if required
- Resizes large images
- Compresses images
- Converts formats
- Generates thumbnails

---

### Step 5 – Generate Image Variants

For every uploaded image, the application creates:

- JPEG (85% Quality)
- JPEG (60% Quality)
- WebP
- PNG
- Thumbnail

Example:

```
photo.jpg

↓

photo_compressed.jpg

photo_low.jpg

photo.webp

photo.png

photo_thumbnail.jpg
```

---

### Step 6 – Store Processed Images

After processing, all generated images are uploaded to the processed S3 bucket.

This keeps the original and processed images separate.

---

### Step 7 – CloudWatch Logging

Every Lambda execution writes logs to CloudWatch.

These logs help monitor the application and troubleshoot issues whenever necessary.

---

## 🔄 Workflow Summary

```
User Uploads Image

↓

Amazon S3

↓

ObjectCreated Event

↓

AWS Lambda

↓

Pillow Processes Image

↓

Generate 5 Variants

↓

Processed Images Stored in S3

↓

CloudWatch Logs
```# 🛠️ Infrastructure as Code (Terraform)

One of the main objectives of this project was to deploy the entire infrastructure using Terraform instead of manually creating resources in the AWS Console.

Terraform creates all required AWS resources with a single command.

```bash
terraform init
terraform plan
terraform apply
```

---

## AWS Resources Created

Terraform provisions the following resources:

- Two Amazon S3 Buckets
- IAM Role
- IAM Policy
- Lambda Function
- Lambda Layer
- CloudWatch Log Group
- S3 Event Notification
- Lambda Permission
- Random ID for unique bucket names

---

## Amazon S3 Buckets

### Upload Bucket

This bucket stores the original images uploaded by users.

Example:

```
holiday.jpg
profile.png
nature.jpeg
```

Whenever a new object is uploaded, it triggers the Lambda function.

---

### Processed Bucket

This bucket stores all processed images created by Lambda.

Example:

```
holiday_compressed.jpg

holiday.webp

holiday_thumbnail.jpg

holiday.png
```

---

## IAM Role

The Lambda function requires permission to access AWS services.

Terraform creates an IAM Role that allows Lambda to:

- Read images from the upload bucket
- Write processed images to the processed bucket
- Create CloudWatch logs

Following the principle of least privilege, only the required permissions are granted.

---

## Lambda Layer

Instead of packaging the Pillow library with every deployment, the project uses a Lambda Layer.

The layer is built using Docker to ensure compatibility with the AWS Lambda runtime.

Benefits include:

- Smaller deployment package
- Faster deployments
- Reusable dependency layer

---

## CloudWatch

CloudWatch automatically stores Lambda logs.

This helps monitor execution and troubleshoot problems during development.

---

## Deployment

Deploying the application is straightforward.

```bash
bash scripts/deploy.sh
```

The deployment script:

- Checks AWS CLI
- Checks Terraform
- Checks Docker
- Builds the Pillow Lambda Layer
- Initializes Terraform
- Plans infrastructure
- Applies infrastructure
- Displays useful outputs

After deployment, Terraform displays:

- Upload Bucket Name
- Processed Bucket Name
- Lambda Function Name
- AWS Region

The application is then ready to process images automatically.





This is actually the most important part. In interviews, they don't want you to memorize code—they want to know **why you built it, how it works, what challenges you faced, and what you learned**.

Below is how I would explain this project in an interview if I were in your position.

---

# 🎤 Interview Explanation

> **Question: Can you explain one of your AWS projects?**

**Answer:**

"I built a serverless image processing pipeline using AWS Lambda, Amazon S3, and Terraform.

The idea behind this project was to automate image optimization. Whenever a user uploads an image to an S3 bucket, an S3 ObjectCreated event automatically triggers an AWS Lambda function.

The Lambda function is written in Python and uses the Pillow library to process the image. It generates multiple versions of the uploaded image, including a compressed JPEG, a low-quality JPEG, a WebP image, a PNG image, and a thumbnail.

After processing, all generated images are stored in another private S3 bucket.

Instead of creating AWS resources manually, I used Terraform to provision the complete infrastructure including S3 buckets, IAM roles, Lambda, Lambda Layer, CloudWatch Log Group, and S3 Event Notifications.

I also wrote Bash scripts to automate deployment and cleanup. Since Pillow contains native binaries, I built the Lambda Layer inside a Linux Docker container to make it compatible with the AWS Lambda runtime.

Through this project, I gained practical experience with serverless architecture, Infrastructure as Code, IAM permissions, Docker, CloudWatch monitoring, and event-driven applications."

---

# Interview Flow

Draw this on paper.

```
User

↓

Upload Image

↓

S3 Upload Bucket

↓

ObjectCreated Event

↓

AWS Lambda

↓

Pillow Library

↓

Generate

Compressed JPEG
Low JPEG
PNG
WEBP
Thumbnail

↓

Processed Bucket

↓

CloudWatch Logs
```

---

# Interview Questions & Answers

---

## 1. Why did you build this project?

**Answer**

I wanted to learn how serverless applications work in AWS. Instead of creating a simple Lambda function, I wanted to build an event-driven application where multiple AWS services communicate automatically.

---

## 2. Why did you choose AWS Lambda?

**Answer**

Lambda allows us to execute code without managing servers.

Advantages:

* No EC2 instance
* Automatic scaling
* Pay only when the function executes
* Easy integration with S3 events

---

## 3. Why did you use Amazon S3?

**Answer**

Amazon S3 is highly durable and scalable.

I used:

* Upload Bucket for original images
* Processed Bucket for optimized images

Keeping them separate makes management easier.

---

## 4. Why two S3 buckets?

**Answer**

One bucket stores original images.

The second bucket stores processed images.

This avoids accidentally triggering Lambda again and keeps the original files unchanged.

---

## 5. Why use S3 Event Notifications?

**Answer**

Instead of manually invoking Lambda, S3 automatically triggers it whenever an object is uploaded.

This creates an event-driven architecture.

---

## 6. Why did you use Pillow?

**Answer**

Pillow is a popular Python image-processing library.

It allows us to:

* Resize images
* Compress images
* Convert formats
* Generate thumbnails

---

## 7. Why create multiple image formats?

**Answer**

Different applications require different image formats.

For example:

* JPEG for photographs
* PNG for transparency
* WebP for faster websites
* Thumbnail for previews

---

## 8. Why did you use Lambda Layer?

**Answer**

Pillow is not included in AWS Lambda by default.

Instead of packaging Pillow every time, I created a reusable Lambda Layer.

Benefits:

* Smaller deployment package
* Faster deployment
* Reusable dependency

---

## 9. Why did you build the layer using Docker?

**Answer**

I developed on Windows.

AWS Lambda runs on Amazon Linux.

If I build Pillow on Windows, it won't work because native binaries are different.

Docker creates the layer in a Linux environment compatible with Lambda.

---

## 10. Why Terraform?

**Answer**

Terraform allows Infrastructure as Code.

Instead of manually creating resources through the AWS Console, I can create everything using code.

Benefits:

* Version control
* Repeatable deployment
* Easy collaboration
* Automation

---

## 11. Which AWS resources did Terraform create?

**Answer**

Terraform created:

* Upload S3 Bucket
* Processed S3 Bucket
* IAM Role
* IAM Policy
* Lambda Layer
* Lambda Function
* CloudWatch Log Group
* Lambda Permission
* S3 Notification
* Random ID

---

## 12. Why IAM Role?

**Answer**

Lambda requires permissions.

The IAM Role allows Lambda to:

* Read objects from Upload Bucket
* Upload processed images
* Write CloudWatch logs

Following least privilege, only necessary permissions are granted.

---

## 13. What is the purpose of CloudWatch?

**Answer**

CloudWatch stores Lambda logs.

It helps monitor execution and troubleshoot errors.

---

## 14. What happens after uploading an image?

**Answer**

1. Image uploaded
2. S3 detects upload
3. Event generated
4. Lambda invoked
5. Lambda downloads image
6. Pillow processes image
7. Generates 5 versions
8. Uploads them to processed bucket
9. Logs stored in CloudWatch

---

## 15. Why use two different S3 buckets instead of one?

**Answer**

If Lambda writes processed images into the same upload bucket, it can trigger itself repeatedly, creating an infinite loop.

Using two buckets prevents this problem.

---

## 16. What security best practices did you implement?

**Answer**

* Private buckets
* Bucket versioning
* Server-side encryption
* Least privilege IAM policy
* No public access
* CloudWatch logging

---

## 17. How did you automate deployment?

**Answer**

I wrote a Bash script named `deploy.sh`.

It:

* Checks AWS CLI
* Checks Terraform
* Checks Docker
* Builds Lambda Layer
* Initializes Terraform
* Plans deployment
* Applies infrastructure
* Displays outputs

---

## 18. How do you clean up resources?

**Answer**

I created a `destroy.sh` script.

It:

* Empties versioned S3 buckets
* Deletes object versions
* Deletes delete markers
* Executes `terraform destroy`

---

## 19. What challenges did you face?

**Answer**

I faced several challenges while building this project:

* Lambda Layer built on Windows was incompatible with AWS Lambda.
* Solved by building the layer using Docker.
* Terraform initially failed because of invalid AWS credentials.
* S3 buckets couldn't be destroyed because versioning was enabled.
* Fixed by writing a cleanup script to delete object versions before destroying resources.

---

## 20. What did you learn?

**Answer**

This project helped me understand:

* Serverless architecture
* Event-driven applications
* Terraform
* IAM
* Docker
* Lambda Layers
* CloudWatch
* S3 Event Notifications
* Infrastructure automation

---

# ⭐ Final HR/Technical Interview Summary (1 Minute)

> "This project is a serverless image processing pipeline built using AWS Lambda, Amazon S3, and Terraform. Whenever an image is uploaded to an S3 bucket, an S3 event automatically triggers a Lambda function written in Python. The function uses the Pillow library to create multiple optimized versions of the image, including compressed JPEGs, WebP, PNG, and thumbnails. The processed images are stored in a separate S3 bucket. I provisioned the complete infrastructure using Terraform, including IAM roles, S3 buckets, Lambda, CloudWatch, and event notifications. I also automated deployment and cleanup using Bash scripts and used Docker to build a Lambda-compatible Pillow Layer. This project gave me hands-on experience with serverless architecture, Infrastructure as Code, IAM security, Docker, and event-driven AWS applications."

---

💡Interviewers often ask follow-up questions based on your explanation, so being comfortable with different levels of detail will make a strong impression.
