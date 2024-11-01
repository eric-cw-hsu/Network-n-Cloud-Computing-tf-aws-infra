resource "aws_instance" "csye6225-webapp" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.csye6225_instance_profile.name
  subnet_id            = aws_subnet.csye6225-aws_subnet_public[0].id
  security_groups = [
    aws_security_group.csye6225-webapp-security-group.id
  ]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  disable_api_termination = false

  key_name = aws_key_pair.csye6225-demo-key-pair.key_name

  // setup configuration
  user_data = <<-EOF
              #!/bin/bash
              touch /tmp/config.yaml
              echo "name: \"Webapp\"" > /tmp/config.yaml
              echo "environment: \"production\"" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "database:" >> /tmp/config.yaml
              echo "  host: ${aws_db_instance.csye6225-postgresql.address}" >> /tmp/config.yaml
              echo "  port: 5432" >> /tmp/config.yaml
              echo "  username: ${aws_db_instance.csye6225-postgresql.username}" >> /tmp/config.yaml
              echo "  password: ${aws_db_instance.csye6225-postgresql.password}" >> /tmp/config.yaml
              echo "  name: ${aws_db_instance.csye6225-postgresql.db_name}" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "server:" >> /tmp/config.yaml
              echo "  port: 8080" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "aws:" >> /tmp/config.yaml
              echo "  region: ${var.region}" >> /tmp/config.yaml
              echo "  bucket_name: ${aws_s3_bucket.csye6225-s3-bucket.bucket}" >> /tmp/config.yaml

              sudo cp /tmp/config.yaml /opt/webapp/config.yaml
              sudo chown csye6225:csye6225 /opt/webapp/config.yaml
              sudo systemctl daemon-reload
              sudo systemctl restart app

              cat <<EOT >> /opt/aws/amazon-cloudwatch-agent/bin/config.json
              {
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/opt/webapp/logs/*.log",
                          "log_group_name": "csye6225",
                          "log_stream_name": "webapp"
                        }
                      ]
                    }
                  }
                }
              }
              EOT

              amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
              sudo systemctl restart amazon-cloudwatch-agent
              
              EOF

  tags = {
    Name = "csye6225-webapp"
  }
}
