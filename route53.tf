resource "aws_route53_record" "csye6225-webapp-lb-dns" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.csye6225-webapp-lb.dns_name
    zone_id                = aws_lb.csye6225-webapp-lb.zone_id
    evaluate_target_health = true
  }
}
