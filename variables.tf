variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "subnet_number" {
  type        = number
  description = "The number of subnets to create"
  default     = 3
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

// Database RDS variables
variable "database_instance_class" {
  type        = string
  description = "The instance class for the database"
  default     = "db.t4g.micro"
}

variable "database_password" {
  type        = string
  description = "The password for the database"
}

variable "database_max_connections" {
  type        = number
  description = "The maximum number of connections to the database"
  default     = 100
}

variable "database_shared_buffers" {
  type        = number
  description = "The amount of memory to allocate for shared buffers"
  default     = 32768
}


// Route 53 variables
variable "route53_zone_id" {
  type        = string
  description = "The ID of the Route 53 zone"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the Route 53 record"
}

// autoscaling group variables
variable "autoscaling_low_threshold" {
  type        = number
  description = "The low threshold for the autoscaling group"
  default     = 7
}

variable "autoscaling_high_threshold" {
  type        = number
  description = "The high threshold for the autoscaling group"
  default     = 10
}

variable "sendgrid_api_key" {
  description = "SendGrid API Key"
}

variable "email_sender_address" {
  description = "Email Sender Address"
}

variable "email_sender_name" {
  description = "Email Sender Name"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
}
