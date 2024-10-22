# setup security group
resource "aws_security_group" "csye6225-webapp-security-group" {
  name        = "csye6225-fall2024-webapp"
  description = "CSYE6225 Fall 2024 Web Application Security Group"
  vpc_id      = aws_vpc.csye6225.id

  ingress {
    description = "Allow HTTP inbound traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS inbound traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH inbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow postgresql outbound traffic"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "csye6225-database-security-group" {
  name        = "csye6225-fall2024-database"
  description = "CSYE6225 Fall 2024 Database Security Group"
  vpc_id      = aws_vpc.csye6225.id

  ingress {
    description     = "Allow PostgreSQL inbound traffic"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.csye6225-webapp-security-group.id]
  }
}
