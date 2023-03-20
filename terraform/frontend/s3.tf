#s3 data
resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "s3-pipeline-3"
}

#s3 deploy
resource "aws_s3_bucket" "demo-tf-test-bucket" {
  bucket = "demo-tf-test-bucket"

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
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#aws_s3_bucket_policy
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.demo-tf-test-bucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.demo-tf-test-bucket.arn}/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
            }
        }
    }
})
  depends_on = [aws_s3_bucket_public_access_block.s3_public_access]
}

#s3_log
#create s3
resource "aws_s3_bucket" "demo-tf-test-bucket-log" {
  bucket = "demo-tf-test-bucket-log"
}

#aws_s3_bucket_policy
resource "aws_s3_bucket_policy" "allow_access_from_another_account_log" {
  bucket = aws_s3_bucket.demo-tf-test-bucket-log.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "Policy1678943829919",
    "Statement" : [
      {
        "Sid" : "Stmt1678943829050",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.demo-tf-test-bucket-log.arn}/*"
      }
    ]
  })
}