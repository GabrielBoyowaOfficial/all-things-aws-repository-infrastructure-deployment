


#---------------------------------------------------------------
# S3 BUCKET FOR WAF LOGS
# Note: AWS requires bucket name to start with "aws-waf-logs-"
#---------------------------------------------------------------

resource "aws_s3_bucket" "waf_logs_bucket" {
  bucket        = var.waf_logs_bucket
  force_destroy = true

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-waf-logs"
    }
  )
}


#---------------------------------------------------------------
# BUCKET POLICY - Allow WAF log delivery service
#---------------------------------------------------------------

data "aws_iam_policy_document" "waf_logs_bucket_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.waf_logs_bucket.arn}/waf-logs/AWSLogs/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.waf_logs_bucket.arn
    ]
  }
}


#---------------------------------------------------------------
# ATTACH POLICY TO BUCKET
#---------------------------------------------------------------

resource "aws_s3_bucket_policy" "waf_logs_bucket_policy_attachment" {
  bucket     = aws_s3_bucket.waf_logs_bucket.id
  policy     = data.aws_iam_policy_document.waf_logs_bucket_policy.json
  depends_on = [aws_s3_bucket.waf_logs_bucket]
}


#---------------------------------------------------------------
# CLOUDWATCH LOG GROUP FOR WAF LOGS
# Note: AWS requires log group name to start with "aws-waf-logs-"
#---------------------------------------------------------------

resource "aws_cloudwatch_log_group" "waf_log_group" {
  name              = "aws-waf-logs-${var.project_name}"
  retention_in_days = 3

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-waf-log-group"
    }
  )
}


#---------------------------------------------------------------
# CLOUDWATCH RESOURCE POLICY - Allow WAFv2 to write to log group
#---------------------------------------------------------------

data "aws_iam_policy_document" "waf_cloudwatch_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.waf_log_group.arn}:*"
    ]
  }
}

resource "aws_cloudwatch_log_resource_policy" "waf_cloudwatch_resource_policy" {
  policy_name     = "${var.project_name}-waf-cloudwatch-policy"
  policy_document = data.aws_iam_policy_document.waf_cloudwatch_policy.json
}


#---------------------------------------------------------------
# WAF LOGGING CONFIGURATION - S3 only (WAFv2 supports one destination)
#---------------------------------------------------------------

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  resource_arn = aws_wafv2_web_acl.alb_waf.arn

  log_destination_configs = [
    aws_s3_bucket.waf_logs_bucket.arn
  ]

  depends_on = [
    aws_s3_bucket_policy.waf_logs_bucket_policy_attachment
  ]
}
