resource "aws_s3_bucket" "bucket01" {
  bucket = "my-tf-test-bucket"
  region = "us-east-2"
  tags   = {
    type = "private"
  }
}