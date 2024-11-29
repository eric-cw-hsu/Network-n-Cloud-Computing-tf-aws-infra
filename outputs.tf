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

output "ec2_private_key_pem" {
  description = "The private key of the EC2 instance"
  value       = tls_private_key.csye6225-demo-key.private_key_pem

  sensitive = true
}

output "aws_s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.csye6225-s3-bucket.id
}

output "aws_account_arn" {
  description = "The ARN of the AWS account"
  value       = data.aws_caller_identity.current.arn
}
