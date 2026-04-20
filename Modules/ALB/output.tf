


#---------------------------------------------------------------
# OUTPUT FILE FOR ALB MODULE
#---------------------------------------------------------------

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}

output "target_group_name" {
  value = aws_lb_target_group.target_group.name
}

output "http_listener_arn" {
  value = aws_lb_listener.http_listener.arn
}

output "alb_logs_bucket_name" {
  value = aws_s3_bucket.alb_logs_bucket.bucket
}

output "alb_logs_bucket_arn" {
  value = aws_s3_bucket.alb_logs_bucket.arn
}

output "waf_web_acl_arn" {
  value = aws_wafv2_web_acl.alb_waf.arn
}

output "waf_web_acl_id" {
  value = aws_wafv2_web_acl.alb_waf.id
}

output "waf_logs_bucket_arn" {
  value = aws_s3_bucket.waf_logs_bucket.arn
}

output "waf_cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.waf_log_group.name
}

output "waf_cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.waf_log_group.arn
}

output "waf_custom_rule_group_arn" {
  value = aws_wafv2_rule_group.custom_rules.arn
}

output "resource_tags" {
  value = var.resource_tags
}
