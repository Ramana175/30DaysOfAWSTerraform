# =============================================================================
# Example: Conditional Expression
# =============================================================================
# Purpose:
# Create different EC2 instance types based on environment.
#
# dev  -> t3.micro
# prod -> t3.medium
# =============================================================================

resource "aws_instance" "web_server" {

  ami = "ami-091138d0f0d41ff90"

  instance_type = var.environment == "prod" ? "t3.medium" : "t3.micro"

  tags = {
    Name        = "conditional-expression-demo"
    Environment = var.environment
  }
}