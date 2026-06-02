# =============================================================================
# Web Server Outputs
# =============================================================================

output "web_server_id" {
  description = "ID of the web server instance"
  value       = aws_instance.web_server.id
}

output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}

