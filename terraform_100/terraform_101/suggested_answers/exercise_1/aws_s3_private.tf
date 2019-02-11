resource "aws_s3_bucket" "bucket01" {
  bucket = "my-tf-test-bucket"

  tags = {
    type        = "private"
  }
}