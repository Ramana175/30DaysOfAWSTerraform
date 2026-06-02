# =============================================================================
# Splat Expressions
# =============================================================================

output "instance_ids" {

  description = "All EC2 Instance IDs"

  value = aws_instance.web_server[*].id
}

output "public_ips" {

  description = "All Public IP Addresses"

  value = aws_instance.web_server[*].public_ip
}

output "private_ips" {

  description = "All Private IP Addresses"

  value = aws_instance.web_server[*].private_ip
}