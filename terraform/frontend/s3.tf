resource "aws_s3_bucket" "test_bucket" {
  bucket = "terraform-test"

  tags = {
    Name = "test"

  }
}
