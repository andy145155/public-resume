data "aws_route53_zone" "root" {
  name         = var.root_domain
  private_zone = false
}

resource "aws_acm_certificate" "resume_redirect" {
  domain_name       = var.resume_domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.resume_redirect.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.root.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60

  records = [each.value.value]
}
