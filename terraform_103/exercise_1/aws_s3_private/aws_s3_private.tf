#Provider declaration
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.bucket_region
}

#Local variables
locals {
  az = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]
}

#Resource declarations
resource "aws_s3_bucket" "bucket01" {
  bucket = var.bucket_name
  region = var.bucket_region

  tags   = {
    type = var.bucket_type_tag
  }
}

#VPC
resource "aws_vpc" "core" {
  cidr_block = var.vpc_cidr
}

#Private Subnets
resource "aws_subnet" "private" {
  count             = length(local.az)
  availability_zone = local.az[count.index % length(local.az)]
  vpc_id            = aws_vpc.core.id
  cidr_block        = cidrsubnet(aws_vpc.core.cidr_block, 6, count.index)
}

#Public Subnets
resource "aws_subnet" "public" {
  count             = length(local.az)
  availability_zone = local.az[count.index % length(local.az)]
  vpc_id            = aws_vpc.core.id
  cidr_block        = cidrsubnet(aws_vpc.core.cidr_block, 3, count.index + 1)
}