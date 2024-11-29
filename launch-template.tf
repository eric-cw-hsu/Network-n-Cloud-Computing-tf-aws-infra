resource "aws_launch_template" "csye6225-webapp-launch-template" {
  name          = "csye6225-fall2024-webapp-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.csye6225_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.csye6225-webapp-security-group.id
    ]
  }

  key_name = aws_key_pair.csye6225-demo-key-pair.key_name
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 25
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.ec2_key.arn
    }
  }

  disable_api_termination = false

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt install unzip -y
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install

              DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.db_password.name} --query SecretString --output text | jq -r '.password')

              touch /tmp/config.yaml
              echo "name: \"Webapp\"" > /tmp/config.yaml
              echo "environment: \"production\"" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "database:" >> /tmp/config.yaml
              echo "  host: ${aws_db_instance.csye6225-postgresql.address}" >> /tmp/config.yaml
              echo "  port: 5432" >> /tmp/config.yaml
              echo "  username: ${aws_db_instance.csye6225-postgresql.username}" >> /tmp/config.yaml
              echo "  password: $DB_PASSWORD" >> /tmp/config.yaml
              echo "  name: ${aws_db_instance.csye6225-postgresql.db_name}" >> /tmp/config.yaml
              echo "  max_open_connections: 14" >> /tmp/config.yaml
              echo "  max_idle_connections: 7" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "server:" >> /tmp/config.yaml
              echo "  port: 8080" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "auth:" >> /tmp/config.yaml
              echo "  verify_email_expiration_time: 60" >> /tmp/config.yaml
              echo "  verification_email_topic_arn: ${aws_sns_topic.csye6225_user_signup_topic.arn}" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "aws:" >> /tmp/config.yaml
              echo "  region: ${var.region}" >> /tmp/config.yaml
              echo "  s3:" >> /tmp/config.yaml
              echo "    bucket_name: ${aws_s3_bucket.csye6225-s3-bucket.bucket}" >> /tmp/config.yaml
              echo "  cloudwatch:" >> /tmp/config.yaml
              echo "    push_interval: 30" >> /tmp/config.yaml
              echo "    buffer_size: 500" >> /tmp/config.yaml

              sudo cp /tmp/config.yaml /opt/webapp/config.yaml
              sudo chown csye6225:csye6225 /opt/webapp/config.yaml

              touch /tmp/config.yaml
              echo "name: \"Webapp\"" > /tmp/config.yaml
              echo "environment: \"production\"" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "database:" >> /tmp/config.yaml
              echo "  host: ${aws_db_instance.csye6225-postgresql.address}" >> /tmp/config.yaml
              echo "  port: 5432" >> /tmp/config.yaml
              echo "  username: ${aws_db_instance.csye6225-postgresql.username}" >> /tmp/config.yaml
              echo "  password: $DB_PASSWORD" >> /tmp/config.yaml
              echo "  name: ${aws_db_instance.csye6225-postgresql.db_name}" >> /tmp/config.yaml
              echo "  max_open_connections: 4" >> /tmp/config.yaml
              echo "  max_idle_connections: 2" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "server:" >> /tmp/config.yaml
              echo "  port: 8081" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "auth:" >> /tmp/config.yaml
              echo "  verify_email_expiration_time: 60" >> /tmp/config.yaml
              echo "  verification_email_topic_arn: ${aws_sns_topic.csye6225_user_signup_topic.arn}" >> /tmp/config.yaml
              echo "" >> /tmp/config.yaml
              echo "aws:" >> /tmp/config.yaml
              echo "  region: ${var.region}" >> /tmp/config.yaml
              echo "  s3:" >> /tmp/config.yaml
              echo "    bucket_name: ${aws_s3_bucket.csye6225-s3-bucket.bucket}" >> /tmp/config.yaml
              echo "  cloudwatch:" >> /tmp/config.yaml
              echo "    push_interval: 30" >> /tmp/config.yaml
              echo "    buffer_size: 500" >> /tmp/config.yaml

              sudo cp /tmp/config.yaml /opt/bak-webapp/config.yaml
              sudo chown csye6225:csye6225 /opt/bak-webapp/config.yaml

              sudo systemctl daemon-reload
              sudo systemctl restart app
              sudo systemctl restart app-bak

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
  )
}
