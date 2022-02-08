resource "aws_route53_zone" "this" {
  name = "immoneyforest.com"
}

resource "aws_route53_record" "this" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "immoneyforest.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "this_acm_c" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60

  allow_overwrite = true
}

resource "aws_acm_certificate" "this" {
  domain_name       = "immoneyforest.com"
  validation_method = "DNS"
  provider          = aws.virginia

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this_acm_c : record.fqdn]
  provider                = aws.virginia
}
