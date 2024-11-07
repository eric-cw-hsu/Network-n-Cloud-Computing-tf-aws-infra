resource "aws_lb" "csye6225-webapp-lb" {
  name               = "web-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.csye6225-loadbalancer-security-group.id
  ]

  subnets = [
    for subnet in aws_subnet.csye6225-aws_subnet_public : subnet.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "csye6225-webapp-lb"
  }
}

resource "aws_lb_target_group" "csye6225-lb-webapp-tg" {
  name     = "csye6225-webapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.csye6225.id

  health_check {
    path = "/healthz"
  }

  tags = {
    Name = "csye6225-lb-webapp-tg"
  }
}

resource "aws_lb_listener" "csye6225-lb-webapp-listener" {
  load_balancer_arn = aws_lb.csye6225-webapp-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.csye6225-lb-webapp-tg.arn
  }
}

resource "aws_autoscaling_attachment" "csye6225-webapp-asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.csye6225-webapp-autoscaling-group.name
  lb_target_group_arn    = aws_lb_target_group.csye6225-lb-webapp-tg.arn
}
