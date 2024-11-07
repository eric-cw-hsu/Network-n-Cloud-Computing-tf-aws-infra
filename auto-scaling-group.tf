resource "aws_autoscaling_group" "csye6225-webapp-autoscaling-group" {
  launch_template {
    id      = aws_launch_template.csye6225-webapp-launch-template.id
    version = "$Latest"
  }

  vpc_zone_identifier = [
    for subnet in aws_subnet.csye6225-aws_subnet_public : subnet.id
  ]

  desired_capacity = 3
  max_size         = 5
  min_size         = 3


  health_check_type         = "EC2"
  health_check_grace_period = 300
  default_cooldown          = 60

  lifecycle {
    create_before_destroy = true
  }


  tag {
    key                 = "Name"
    value               = "webapp-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "csye6225-webapp-autoscaling-policy-scale-up" {
  name                   = "csye6225-webapp-autoscaling-policy-scale-up"
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.csye6225-webapp-autoscaling-group.name
  scaling_adjustment     = 1

  cooldown = 60
}

resource "aws_autoscaling_policy" "csye6225-webapp-autoscaling-policy-scale-down" {
  name                   = "csye6225-webapp-autoscaling-policy-scale-down"
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.csye6225-webapp-autoscaling-group.name
  scaling_adjustment     = -1

  cooldown = 60
}

resource "aws_cloudwatch_metric_alarm" "csye6225-webapp-cpu-utilization-high" {
  alarm_name          = "High_CPU_Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.autoscaling_high_threshold
  alarm_actions       = [aws_autoscaling_policy.csye6225-webapp-autoscaling-policy-scale-up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225-webapp-autoscaling-group.name
  }
}

resource "aws_cloudwatch_metric_alarm" "csye6225-webapp-cpu-utilization-low" {
  alarm_name          = "Low_CPU_Usage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.autoscaling_low_threshold
  alarm_actions       = [aws_autoscaling_policy.csye6225-webapp-autoscaling-policy-scale-down.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225-webapp-autoscaling-group.name
  }
}
