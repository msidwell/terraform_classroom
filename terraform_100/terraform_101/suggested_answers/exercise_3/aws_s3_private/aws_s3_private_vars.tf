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