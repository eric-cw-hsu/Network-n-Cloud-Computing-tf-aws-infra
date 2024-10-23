resource "tls_private_key" "csye6225-demo-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "csye6225-demo-key-pair" {
  key_name   = "csye6225-demo-key"
  public_key = tls_private_key.csye6225-demo-key.public_key_openssh
}
