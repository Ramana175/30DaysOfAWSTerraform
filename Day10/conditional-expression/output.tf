output "instance_id" {
  value = aws_instance.web_server.id
}

output "environment" {
  value = var.environment
}

output "instance_type" {
  value = aws_instance.web_server.instance_type
}