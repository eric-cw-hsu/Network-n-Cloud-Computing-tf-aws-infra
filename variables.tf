variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "subnet_number" {
  type        = number
  description = "The number of subnets to create"
}

variable "region" {
  type        = string
  description = "The region in which to create the VPC"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "ami_id" {
  type        = string
  description = "The ID of the AMI to use for the instances"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to launch"
  default     = "t2.micro"
}

variable "database_instance_class" {
  type        = string
  description = "The instance class for the database"
  default     = "db.t4g.micro"
}

variable "database_password" {
  type        = string
  description = "The password for the database"
}

variable "route53_zone_id" {
  type        = string
  description = "The ID of the Route 53 zone"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the Route 53 record"
}
