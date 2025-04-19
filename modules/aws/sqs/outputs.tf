output "queue_arn" {
  value       = aws_sqs_queue.this.arn
  description = "ARN of the SQS queue"
}

output "queue_id" {
  value       = aws_sqs_queue.this.id
  description = "URL of the SQS queue"
}

output "queue_name" {
  value       = aws_sqs_queue.this.name
  description = "Name of the SQS queue"
} 

output "queue_url" {
  value       = aws_sqs_queue.this.url
  description = "URL of the SQS queue"
}
