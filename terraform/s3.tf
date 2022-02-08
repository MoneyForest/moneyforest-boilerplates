resource "aws_s3_bucket" "this" {
  bucket_prefix = "this"
  acl           = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_object" "index_page" {
  bucket       = aws_s3_bucket.this.id
  key          = "index.html"
  source       = "www/index.html"
  content_type = "text/html"
  etag         = filemd5("../www/index.html")
}
