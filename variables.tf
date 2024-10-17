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
