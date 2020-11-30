#Variable declarations
variable "aws_access_key" {
  type        = string
  description = "AWS access key for principle"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS principle secret"
}

variable "bucket_name" {
  type        = string
  description = "Name for new S3 bucket"
  default     = "my-tf-test-bucket"
}

variable "bucket_region" {
  type        = string
  description = "Region for new S3 bucket"
  default     = "us-east-2"
}

variable "bucket_type_tag" {
  type        = string
  description = "Type tag for new S3 bucket"
  default     = "private"
}

variable "vpc_cidr" {
    type = string
    default = "172.20.0.0/16"
    description = "Core VPC CIDR"
}