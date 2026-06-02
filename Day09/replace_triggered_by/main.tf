# =============================================================================
# Security Group
# =============================================================================

resource "aws_security_group" "app_sg" {

  name = "replace-trigger-demo"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# =============================================================================
# EC2 Instance
# =============================================================================

resource "aws_instance" "app_server" {

  ami           = "ami-091138d0f0d41ff90"
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  lifecycle {

    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]

  }

  tags = {
    Name = "replace-trigger-demo"
  }
}