# Create a Public Route Table
resource "aws_route_table" "csye6225-aws_route_table_public" {
  vpc_id = aws_vpc.csye6225.id
  tags = {
    Name = "csye6225-public-route-table"
  }
}

# Attach public subnets to the Public Route Table
resource "aws_route_table_association" "csye6225-aws_route_table_association_public" {
  count = length(aws_subnet.csye6225-aws_subnet_public)

  subnet_id      = aws_subnet.csye6225-aws_subnet_public[count.index].id
  route_table_id = aws_route_table.csye6225-aws_route_table_public.id
}

# Create a Private Route Table
resource "aws_route_table" "csye6225-aws_route_table_private" {
  vpc_id = aws_vpc.csye6225.id
  tags = {
    Name = "csye6225-private-route-table"
  }
}

# Attach private subnets to the Private Route Table
resource "aws_route_table_association" "csye6225-aws_route_table_association_private" {
  count = length(aws_subnet.csye6225-aws_subnet_private)

  subnet_id      = aws_subnet.csye6225-aws_subnet_private[count.index].id
  route_table_id = aws_route_table.csye6225-aws_route_table_private.id
}

# Create a route in the public route table to route internet traffic
resource "aws_route" "csye6225-public_internet_route" {
  route_table_id         = aws_route_table.csye6225-aws_route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.csye6225-aws_internet_gateway.id
}
