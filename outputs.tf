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
