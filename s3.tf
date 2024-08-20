resource "aws_s3_bucket" "resume_redirect" {
  bucket = var.resume_domain
}

resource "aws_s3_bucket_public_access_block" "resume_redirect" {
  bucket                  = aws_s3_bucket.resume_redirect.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "resume_redirect" {
  bucket = aws_s3_bucket.resume_redirect.id
  policy = data.aws_iam_policy_document.cloudfront_oac.json
}

data "aws_iam_policy_document" "cloudfront_oac" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.resume_redirect.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.resume_redirect.arn]
    }
  }
}

