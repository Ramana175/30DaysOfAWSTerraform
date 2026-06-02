output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.demo_server.id
}

output "public_ip" {
  description = "Public IP Address"
  value       = aws_instance.demo_server.public_ip
}