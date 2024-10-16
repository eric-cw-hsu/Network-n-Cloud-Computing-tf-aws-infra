resource "aws_instance" "my_ec2" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.csye6225-aws_subnet_public[0].id
  security_groups = [
    aws_security_group.csye6225-security-group.id
  ]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  disable_api_termination = false

  tags = {
    Name = "my-ec2-instance"
  }
}
