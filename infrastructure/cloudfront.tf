# Create the CloudFront Origin Access Control for the S3 bucket
resource "aws_cloudfront_origin_access_control" "resume_redirect" {
  name                              = "resume_redirect"
  description                       = "CloudFront access to S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Use AWS Managed Caching Policy for optimized caching
data "aws_cloudfront_cache_policy" "cache_optimized" {
  name = "Managed-CachingOptimized"
}

# Create the CloudFront distribution
resource "aws_cloudfront_distribution" "resume_redirect" {
  http_version = "http2and3"
  aliases      = [var.resume_domain]
  enabled      = true

  origin {
    domain_name              = aws_s3_bucket.resume_redirect.bucket_regional_domain_name
    origin_id                = "S3-Resume-Origin" # Unique identifier for this origin
    origin_access_control_id = aws_cloudfront_origin_access_control.resume_redirect.id
  }

  default_cache_behavior {
    target_origin_id       = "S3-Resume-Origin" # Reference the origin by its unique ID
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.cache_optimized.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.resume_redirect_function.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.resume_redirect.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

}

# Create the CloudFront Function for redirection
resource "aws_cloudfront_function" "resume_redirect_function" {
  name    = "resumeRedirectFunction"
  runtime = "cloudfront-js-2.0"
  code    = file("${path.module}/cloudfrontFunctions/redirectToExternalSite.js")
}

# Create the Route 53 record for your resume domain
resource "aws_route53_record" "movie_app_www_domain" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = var.resume_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.resume_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.resume_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}
