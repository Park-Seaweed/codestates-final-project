resource "aws_s3_bucket" "name" {
  bucket = "terraform-test"
  acl    = "private"
  tags = {
    Name = "test"

  }
}
