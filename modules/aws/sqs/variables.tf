variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
}

variable "environment" {
  description = "Tag for environment"
  type        = string
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it"
  type        = number
  default     = 262144 # 256 KiB
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  type        = number
  default     = 345600 # 4 days
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive"
  type        = number
  default     = 0
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue"
  type        = number
  default     = 30
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "redrive_policy_enabled" {
  description = "Boolean designating whether to enable the redrive policy for DLQ"
  type        = bool
  default     = false
}

variable "max_receive_count" {
  description = "The number of times a message can be unsuccessfully dequeued before being moved to the dead-letter queue"
  type        = number
  default     = 5
}

variable "dead_letter_queue_arn" {
  description = "The ARN of the dead-letter queue to which SQS moves messages"
  type        = string
  default     = null
}

variable "policy_principal" {
  description = "The principal who is getting the permission"
  type        = any
  default     = "*"
}

variable "policy_actions" {
  description = "The SQS actions this policy allows"
  type        = list(string)
  default     = ["sqs:SendMessage"]
}

variable "policy_condition" {
  description = "Conditions for the policy (optional)"
  type        = any
  default     = {}
} 
