# =============================================================================
# Example 3: ignore_changes
# =============================================================================
# Purpose:
# Ignore tag changes made outside Terraform.
#
# Demo:
# 1. Create EC2 instance
# 2. Manually add a tag in AWS Console
# 3. Run terraform plan
# 4. Terraform ignores the tag modification
# =============================================================================

resource "aws_instance" "demo_server" {

  ami           = "ami-091138d0f0d41ff90"
  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    Environment = "dev"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}