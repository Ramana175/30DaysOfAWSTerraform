terraform {
  backend "s3" {
    bucket = "ramana175-terraform-state-2026"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}