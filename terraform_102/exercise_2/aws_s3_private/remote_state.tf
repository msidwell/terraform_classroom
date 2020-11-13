terraform {
  backend "s3" {
    bucket = "my-fresh-bucket"
    key    = "path/to/my/statefile.tfstate"
    region = "us-east-2"
  }
}