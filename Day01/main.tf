# Day 01 - Terraform Basics
# Provider Configuration

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

# Basic EC2 Instance
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
