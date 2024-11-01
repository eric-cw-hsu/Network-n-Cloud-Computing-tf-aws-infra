resource "aws_route53_record" "web_app" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300

  records = [aws_instance.csye6225-webapp.public_ip]
}
