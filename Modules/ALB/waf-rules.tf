


#---------------------------------------------------------------
# CUSTOM WAF RULE GROUP
#---------------------------------------------------------------

resource "aws_wafv2_rule_group" "custom_rules" {
  name     = "${var.project_name}-custom-rules"
  scope    = "REGIONAL"
  capacity = 100

  #---------------------------------------------------------------
  # RULE 1 - Rate limit per IP (blocks if > 1000 req / 5 min)
  #---------------------------------------------------------------
  rule {
    name     = "RateLimitPerIP"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 3000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-rate-limit"
      sampled_requests_enabled   = true
    }
  }


  #---------------------------------------------------------------
  # RULE 2 - Block requests with suspicious URI size (> 2048 bytes)
  #---------------------------------------------------------------
  rule {
    name     = "BlockOversizedURI"
    priority = 2

    action {
      block {}
    }

    statement {
      size_constraint_statement {
        comparison_operator = "GT"
        size                = 2048

        field_to_match {
          uri_path {}
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-oversized-uri"
      sampled_requests_enabled   = true
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-custom-rules"
    sampled_requests_enabled   = true
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-custom-rules"
    }
  )
}
