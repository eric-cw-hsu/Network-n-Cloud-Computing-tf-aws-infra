output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.csye6225.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.csye6225.arn
}

output "availability_zone" {
  description = "The availability zone"
  value       = data.aws_availability_zones.available.names
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.csye6225-webapp.id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.csye6225-webapp.public_ip
}

output "ec2_private_key_pem" {
  description = "The private key of the EC2 instance"
  value       = tls_private_key.csye6225-demo-key.private_key_pem

  sensitive = true
}
