module "video_processing_queue" {
  source = "./modules/aws/sqs"

  queue_name  = "${var.project_name}-video-processing-queue"
  environment = var.environment

  visibility_timeout_seconds = 300     # 5 minutes
  message_retention_seconds  = 1209600 # 14 days

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