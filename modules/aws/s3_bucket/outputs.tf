output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of the bucket"
}

output "bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "Name (ID) of the bucket"
}
