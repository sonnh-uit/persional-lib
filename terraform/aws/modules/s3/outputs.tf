output "bucket_information" {
    description = "list all of information of bucket"
    value = [
        {
            "bucket-name" : aws_s3_bucket.example_bucket.id,
            "bucket-arn" : aws_s3_bucket.example_bucket.arn,
            "bucket-domain-name" : aws_s3_bucket.example_bucket.bucket_domain_name,
        }
    ]
  
}