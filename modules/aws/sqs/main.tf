resource "aws_sqs_queue" "this" {
  name                        = var.queue_name
  delay_seconds               = var.delay_seconds
  max_message_size            = var.max_message_size
  message_retention_seconds   = var.message_retention_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication

  tags = {
    Name        = var.queue_name
    Environment = var.environment
    Provisioner = "Terraform"
  }
}

resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = var.policy_principal
        Action    = var.policy_actions
        Resource  = aws_sqs_queue.this.arn
        Condition = var.policy_condition
      }
    ]
  })
} 
