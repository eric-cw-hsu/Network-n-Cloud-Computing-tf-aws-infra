resource "aws_subnet" "csye6225-aws_subnet_public" {
  count = var.subnet_number

  vpc_id                  = aws_vpc.csye6225.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "csye6225-aws_subnet_private" {
  count = var.subnet_number

  vpc_id                  = aws_vpc.csye6225.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_number)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index}"
  }
}
