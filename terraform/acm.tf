resource "aws_acm_certificate" "weather" {
  domain_name       = "*.trakadev.net"
  validation_method = "DNS"

  tags = {
    Name = "weather"
  }
}

resource "aws_route53_record" "weather" {
  for_each = {
    for dvo in aws_acm_certificate.weather.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.trakadev.zone_id
}

resource "aws_acm_certificate_validation" "weather" {
  certificate_arn         = aws_acm_certificate.weather.arn
  validation_record_fqdns = [for record in aws_route53_record.weather : record.fqdn]
}
