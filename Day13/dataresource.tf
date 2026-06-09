# Default VPC
data "aws_vpc" "shared_vpc" {
  default = true
}

# Existing Subnet
data "aws_subnet" "shared_subnet" {
  id = "subnet-048c6d19315439882"
}

# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}