resource "aws_s3_bucket" "example_bucket" {
    bucket_prefix = var.bucket_name_prefix
  
}