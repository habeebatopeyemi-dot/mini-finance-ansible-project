output "public_ip" {
  value = aws_instance.EC2_instance.public_ip
  description = "The public IP address of the EC2 instance"
}

output "instance_id" {
  value = aws_instance.EC2_instance.id
  description = "The ID of the EC2 instance"
}
