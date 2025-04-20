output "alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.this.arn
  description = "ARN of the CloudWatch alarm"
}

output "alarm_id" {
  value       = aws_cloudwatch_metric_alarm.this.id
  description = "ID of the CloudWatch alarm"
}

output "alarm_name" {
  value       = aws_cloudwatch_metric_alarm.this.alarm_name
  description = "Name of the CloudWatch alarm"
} 
