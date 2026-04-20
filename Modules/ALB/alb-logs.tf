


#---------------------------------------------------------------
# Create the S3 bucket to store the ALB Access Logs
#---------------------------------------------------------------

resource "aws_s3_bucket" "alb_logs_bucket" {
  bucket        = var.alb_logs_bucket
  force_destroy = true

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-alb-logs"
    }
  )
}


#---------------------------------------------------------------
# BUCKET POLICY - Allow ELB service to deliver logs
#---------------------------------------------------------------

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "alb_logs_bucket_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.alb_logs_bucket.arn}/alb-logs/AWSLogs/*"
    ]
  }

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
      "${aws_s3_bucket.alb_logs_bucket.arn}/alb-logs/AWSLogs/*"
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
      aws_s3_bucket.alb_logs_bucket.arn
    ]
  }
}


#---------------------------------------------------------------
# ATTACH POLICY TO BUCKET
#---------------------------------------------------------------

resource "aws_s3_bucket_policy" "alb_logs_bucket_policy_attachment" {
  bucket     = aws_s3_bucket.alb_logs_bucket.id
  policy     = data.aws_iam_policy_document.alb_logs_bucket_policy.json
  depends_on = [aws_s3_bucket.alb_logs_bucket]
}
