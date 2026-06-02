# =============================================================================
# Example 1: create_before_destroy
# =============================================================================
# Use Case:
# Create a new EC2 instance before destroying the existing one.
#
# Benefit:
# Prevents downtime during infrastructure updates such as:
# - AMI changes
# - Instance type changes
# - Configuration updates
#
# Without create_before_destroy:
# Old Instance -> Destroyed
# New Instance -> Created
# Result: Downtime
#
# With create_before_destroy:
# New Instance -> Created
# Old Instance -> Destroyed
# Result: Zero/Minimal Downtime
# =============================================================================

resource "aws_instance" "web_server" {

  ami           = "ami-091138d0f0d41ff90"   
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
    Demo = "create_before_destroy"
  }

  # Lifecycle Rule
  # Create replacement instance before destroying current instance

  lifecycle {
    create_before_destroy = true
  }
}