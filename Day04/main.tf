
terraform {
    
 backend "s3" {
    bucket = "ramana-175-bucket"
    key    = "Dev/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-tf-test-bucket-96402"

  tags = {
    Name        = "My_bucket"
    Environment = "Dev"
  }
}

