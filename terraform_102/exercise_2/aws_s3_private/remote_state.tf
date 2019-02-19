terraform {
  backend "s3" {
    bucket = "my-fresh-bucket"
    key    = "secret/path/to/my/secret/key"
    region = "us-east-2"
  }
}