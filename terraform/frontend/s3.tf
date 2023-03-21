#s3 data
resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "dev-s3-pipeline-1"
}

#s3 deploy
resource "aws_s3_bucket" "demo-tf-test-bucket" {
  bucket = "dev-tf-bucket"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_acl" "demo-tf-test-bucket-acl" {
  bucket = aws_s3_bucket.demo-tf-test-bucket.id
  acl    = "private"
}

# aws_s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.demo-tf-test-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#aws_s3_bucket_policy
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.demo-tf-test-bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "cloudfront.amazonaws.com"
      },
      "Action" : "s3:GetObject",
      "Resource" : "${aws_s3_bucket.demo-tf-test-bucket.arn}/*",
      "Condition" : {
        "StringEquals" : {
          "AWS:SourceArn" : "${aws_cloudfront_distribution.s3_distribution.arn}"
        }
      }
    }
  })
}


