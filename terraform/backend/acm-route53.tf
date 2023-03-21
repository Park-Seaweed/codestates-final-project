resource "aws_acm_certificate" "cert" {
  domain_name       = "*.devops03-gg.click"
  validation_method = "DNS"

  tags = {
    Name = "yourdomain.com-certificate"
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.final_ecs_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
  }
}

resource "aws_route53_record" "alb" {
  name    = "dev.devops03-gg.click"
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_lb.final_ecs_alb.dns_name
    zone_id                = aws_lb.final_ecs_alb.zone_id
    evaluate_target_health = false
  }

  lifecycle {
    create_before_destroy = false
  }
}
