#Resource declarations
resource "aws_s3_bucket" "bucket01" {
  bucket = var.bucket_name
  region = var.bucket_region

  tags   = {
    type = var.bucket_type_tag
  }
}