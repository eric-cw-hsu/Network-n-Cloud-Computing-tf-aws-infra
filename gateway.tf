resource "aws_internet_gateway" "csye6225-aws_internet_gateway" {
  vpc_id = aws_vpc.csye6225.id

  tags = {
    Name = "csye6225"
  }
}
