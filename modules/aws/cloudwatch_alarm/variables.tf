variable "alarm_name" {
  description = "The name of the alarm"
  type        = string
}

variable "environment" {
  description = "Tag for environment"
  type        = string
}

variable "comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified statistic and threshold"
  type        = string
  default     = "GreaterThanOrEqualToThreshold"
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  type        = number
  default     = 1
}

variable "metric_name" {
  description = "The name of the metric to alarm on"
  type        = string
}

variable "namespace" {
  description = "The namespace for the alarm's metric"
  type        = string
  default     = "AWS/SQS"
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied"
  type        = number
  default     = 60 # 1 minute
}

variable "statistic" {
  description = "The statistic to apply to the alarm's metric"
  type        = string
  default     = "Sum"
}

variable "threshold" {
  description = "The value against which the specified statistic is compared"
  type        = number
  default     = 1
}

variable "alarm_description" {
  description = "The description for the alarm"
  type        = string
  default     = "CloudWatch alarm for resource"
}

variable "datapoints_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm"
  type        = number
  default     = 1
}

variable "treat_missing_data" {
  description = "How the alarm handles missing data points"
  type        = string
  default     = "notBreaching"
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions to the ALARM state"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "The list of actions to execute when this alarm transitions to the OK state"
  type        = list(string)
  default     = []
}

variable "dimensions" {
  description = "The dimensions for the alarm's metric"
  type        = map(string)
} 
