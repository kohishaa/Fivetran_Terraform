output "destination_id"{
    value = fivetran_destination.destination.id
}

output "bucket_name" {
  value = aws_s3_bucket.fivetran_bucket.bucket
}
