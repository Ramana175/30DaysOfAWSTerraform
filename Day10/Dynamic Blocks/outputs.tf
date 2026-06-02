output "security_group_id" {
  value = aws_security_group.dynamic_sg.id
}

output "ingress_rules" {
  value = var.ingress_rules
}

output "egress_rules" {
  value = var.egress_rules
}