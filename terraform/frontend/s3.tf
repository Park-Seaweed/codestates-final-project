resource "aws_s3_bucket" "test_bucket" {
  bucket = "terraform-test-alsgur"
  tags = {
    Name = "test"

  }
}
