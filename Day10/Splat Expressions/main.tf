# =============================================================================
# Example: Splat Expressions
# =============================================================================
# Purpose:
# Create multiple EC2 instances using count
# and extract their attributes using the
# splat operator [*]
# =============================================================================

resource "aws_instance" "web_server" {

  count = var.instance_count

  ami           = "ami-091138d0f0d41ff90"
  instance_type = var.instance_type

  tags = {
    Name = "web-server-${count.index + 1}"
  }
}