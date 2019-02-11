#Variable declarations
variable "bucket_name" {
  type        = "string"
  description = "Name for new S3 bucket"
  default     = "my-tf-test-bucket"
}

variable "bucket_region" {
  type        = "string"
  description = "Region for new S3 bucket"
  default     = "us-east-2"
}

variable "bucket_type_tag" {
  type        = "string"
  description = "Type tag for new S3 bucket"
  default     = "private"
}

#Resource declarations
resource "aws_s3_bucket" "bucket01" {
  bucket = "${var.bucket_name}"
  region = "${var.bucket_region}"

  tags   = {
    type = "${var.bucket_type_tag}"
  }
}