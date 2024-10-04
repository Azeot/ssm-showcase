resource "aws_s3_bucket" "artifacts_bucket" {
  bucket        = "showcase.artifacts.bucket"
  force_destroy = true
  tags = {
    "Name" = "ssm-showcase"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts_bucket_lc" {
  bucket = aws_s3_bucket.artifacts_bucket.bucket
  rule {
    id = "expire_all"
    filter {}
    status = "Enabled"
    expiration {
      days = 1
    }
  }
}

resource "aws_iam_role_policy" "instance_access_bucket" {
  name = "Allow-bucket-access"
  role = aws_iam_role.instance.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:*"]
        Resource = [
          "${aws_s3_bucket.artifacts_bucket.arn}",
          "${aws_s3_bucket.artifacts_bucket.arn}/*"
        ]
      }
    ]
  })
}