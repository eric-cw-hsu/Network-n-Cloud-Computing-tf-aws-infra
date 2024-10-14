resource "aws_vpc" "csye6225" {
  cidr_block = var.vpc_cidr
                tags = {
    Name = "${var.vpc_name}-vpc"
  }
}
