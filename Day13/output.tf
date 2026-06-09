output "instance_id" {
  value = aws_instance.day13_instance.id
}

output "private_ip" {
  value = aws_instance.day13_instance.private_ip
}

output "vpc_id" {
  value = data.aws_vpc.shared_vpc.id
}

output "subnet_id" {
  value = data.aws_subnet.shared_subnet.id
}

output "ami_id" {
  value = data.aws_ami.amazon_linux.id
}