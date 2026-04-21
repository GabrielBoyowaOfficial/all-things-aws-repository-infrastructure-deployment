


#---------------------------------------------------------------
# Create the S3 bucket to store the VPC Flow Logs
#---------------------------------------------------------------


resource "aws_s3_bucket" "vpc_flow_logs_bucket" {
  bucket        = var.vpc_flow_logs_bucket
  force_destroy = true

  tags = merge(

    var.resource_tags,

    {
      Name = "${var.project_name}-vpc"
    }
  )
}


#---------------------------------------------------------------
# BUCKET POLICY
#---------------------------------------------------------------

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "vpc_flow_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowVPCFlowLogsWrite"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.vpc_flow_logs_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"    = "bucket-owner-full-control"
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid    = "AllowVPCFlowLogsAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.vpc_flow_logs_bucket.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}


#---------------------------------------------------------------
# 3. Create the VPC Flow Log resource
#---------------------------------------------------------------

resource "aws_flow_log" "example_flow_log" {
  vpc_id               = aws_vpc.vpc.id
  log_destination      = aws_s3_bucket.vpc_flow_logs_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"

  max_aggregation_interval = 60
}



