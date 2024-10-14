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
