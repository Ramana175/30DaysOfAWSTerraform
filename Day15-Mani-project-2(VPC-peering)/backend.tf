terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-venkataramana-vpc-peering-demo"
    key    = "lessons/day15/terraform.tfstate"
    region = "us-east-1"
  }
}