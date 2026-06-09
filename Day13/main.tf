provider "aws" {
  region = var.region
}

resource "aws_instance" "day13_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = data.aws_subnet.shared_subnet.id

  tags = {
    Name = "day13-instance"
  }
}