resource "aws_s3_bucket" "name" {
  bucket = "terraform-test"

  tags = {
    Name = "test"

  }
}
