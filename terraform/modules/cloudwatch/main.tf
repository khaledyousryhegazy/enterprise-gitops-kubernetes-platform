module "sns_topic" {
  source = "terraform-aws-modules/sns/aws"

  name = "${var.name_prefix}-sns-topic"

  tags = var.tags
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = module.sns_topic.topic_arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}

module "log_group" {
  source            = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version           = "~> 3.0"
  name              = "${var.name_prefix}-log-group"
  retention_in_days = 120
}

module "log_metric_filter" {
  source         = "terraform-aws-modules/cloudwatch/aws//modules/log-metric-filter"
  version        = "~> 3.0"
  log_group_name = module.log_group.cloudwatch_log_group_name

  name    = "metric-${module.log_group.cloudwatch_log_group_name}"
  pattern = "ERROR"

  metric_transformation_namespace = var.metric_transformation_namespace
  metric_transformation_name      = var.metric_transformation_name
  metric_transformation_value     = "1"
}

module "alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "log-errors-${module.log_group.cloudwatch_log_group_name}"
  alarm_description   = "Log errors are too high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 10
  period              = 60
  unit                = "Count"

  namespace   = var.metric_transformation_namespace
  metric_name = var.metric_transformation_name
  statistic   = "Sum"

  alarm_actions = [module.sns_topic.topic_arn]
}

