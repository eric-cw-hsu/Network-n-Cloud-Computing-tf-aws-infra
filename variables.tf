variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "subnet_number" {
  type        = number
  description = "The number of subnets to create"
}
