module "video_processing_dlq" {
  source = "./modules/aws/sqs"

  queue_name  = "${var.project_name}-video-processing-dlq"
  environment = var.environment

  # Extended message retention for DLQ
  message_retention_seconds = 1209600 # 14 days

  # Same policy as the main queue
  policy_principal = {
    "Service" : "s3.amazonaws.com"
  }
  policy_actions = ["sqs:SendMessage"]
  policy_condition = {
    "ArnEquals" : {
      "aws:SourceArn" : module.hackathon_video_bucket.bucket_arn
    }
  }
}

module "video_processing_queue" {
  source = "./modules/aws/sqs"

  queue_name  = "${var.project_name}-video-processing-queue"
  environment = var.environment

  visibility_timeout_seconds = 300     # 5 minutes
  message_retention_seconds  = 1209600 # 14 days

  # Enable DLQ redrive policy
  redrive_policy_enabled = true
  max_receive_count      = 5 # After 5 failed attempts, messages go to DLQ
  dead_letter_queue_arn  = module.video_processing_dlq.queue_arn

  policy_principal = {
    "Service" : "s3.amazonaws.com"
  }
  policy_actions = ["sqs:SendMessage"]
  policy_condition = {
    "ArnEquals" : {
      "aws:SourceArn" : module.hackathon_video_bucket.bucket_arn
    }
  }
}

# CloudWatch alarm to monitor messages in the DLQ
module "video_processing_dlq_alarm" {
  source = "./modules/aws/cloudwatch_alarm"

  alarm_name        = "${var.project_name}-video-processing-dlq-alarm"
  environment       = var.environment
  alarm_description = "Alarm when any messages arrive in the video processing DLQ"

  # SQS metrics
  namespace   = "AWS/SQS"
  metric_name = "ApproximateNumberOfMessagesVisible"
  dimensions = {
    QueueName = module.video_processing_dlq.queue_name
  }

  # Alarm if there's even a single message in the DLQ
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  period              = 60 # Check every minute
  evaluation_periods  = 1
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"

  # Add SNS topic ARN here if you want to receive notifications
  # alarm_actions = [aws_sns_topic.alerts.arn]
}

# FIFO queue that is going to receive messages from my video processing lambda and be consumed by my EKS backend
module "processing_job_status_queue_fifo" {
  source = "./modules/aws/sqs"

  queue_name  = "processing-job-status-queue.fifo"
  environment = var.environment

  fifo_queue = true
}

module "notification_queue" {
  source = "./modules/aws/sqs"

  queue_name  = "notification-queue"
  environment = var.environment
}

# S3 bucket notification configuration
resource "aws_s3_bucket_notification" "video_upload_notification" {
  bucket = module.hackathon_video_bucket.bucket_id

  # For files in any {videoId}/raw/ path
  # S3 doesn't support wildcards in filter_prefix, so we need multiple rules
  # or a lambda function for complex filtering

  queue {
    id            = "video-raw-files-upload"
    queue_arn     = module.video_processing_queue.queue_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "raw/"
  }

  depends_on = [module.video_processing_queue]
}
