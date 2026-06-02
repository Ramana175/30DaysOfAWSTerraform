resource "aws_security_group" "dynamic_sg" {

  name        = "dynamic-block-demo"
  description = "Security Group using Dynamic Blocks"

  # ===========================================================================
  # Dynamic Ingress Rules
  # ===========================================================================

  dynamic "ingress" {

    for_each = var.ingress_rules

    content {

      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks

    }
  }

  # ===========================================================================
  # Dynamic Egress Rules
  # ===========================================================================

  dynamic "egress" {

    for_each = var.egress_rules

    content {

      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks

    }
  }

  tags = {
    Name        = "dynamic-block-demo"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}