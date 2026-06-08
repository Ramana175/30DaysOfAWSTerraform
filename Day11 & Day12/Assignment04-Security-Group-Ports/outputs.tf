# =============================================================================
# Outputs
# =============================================================================

output "original_ports" {

  value = var.allowed_ports
}

output "port_list" {

  value = local.port_list
}

output "joined_ports" {

  value = local.joined_ports
}

output "security_group_id" {

  value = aws_security_group.web_sg.id
}