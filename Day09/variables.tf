# AWS Region

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# =============================================================================
# Environment Variable
# =============================================================================
# Used to identify the deployment environment
# Examples:
# - dev
# - test
# - staging
# - prod
# =============================================================================

variable "environment" {
  description = "The environment for the instance"
  type        = string
  default     = "dev"
}

# =============================================================================
# EC2 Instance Type
# =============================================================================
# Specifies the EC2 instance size.
#
# Common Examples:
# t3.micro  -> Free Tier Eligible
# t3.small  -> Small workloads
# t3.medium -> Medium workloads
# =============================================================================

variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t3.micro"
}

# =============================================================================
# EC2 Instance Name
# =============================================================================
# Used as the Name tag for the EC2 instance.
# Helps identify resources in the AWS Console.
# =============================================================================

variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "lifecycle-demo-instance"
}