output "instance_id" {
  value = aws_instance.app_server.id
}

output "security_group_id" {
  value = aws_security_group.app_sg.id
}