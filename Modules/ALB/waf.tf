


#---------------------------------------------------------------
# WAF WEB ACL
#---------------------------------------------------------------

resource "aws_wafv2_web_acl" "alb_waf" {
  name  = "${var.project_name}-alb-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }


  #---------------------------------------------------------------
  # MANAGED RULE 1 - AWS Common Rule Set (OWASP top 10 basics)
  #---------------------------------------------------------------
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-common-rules"
      sampled_requests_enabled   = true
    }
  }


  #---------------------------------------------------------------
  # MANAGED RULE 2 - Known Bad Inputs (Log4j, SSRF, etc.)
  #---------------------------------------------------------------
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-bad-inputs"
      sampled_requests_enabled   = true
    }
  }


  #---------------------------------------------------------------
  # MANAGED RULE 3 - SQL Injection protection
  #---------------------------------------------------------------
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-sqli"
      sampled_requests_enabled   = true
    }
  }


  #---------------------------------------------------------------
  # CUSTOM RULE GROUP - rate limiting + URI size (from waf-rules.tf)
  #---------------------------------------------------------------
  rule {
    name     = "CustomRuleGroup"
    priority = 4

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.custom_rules.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-custom-rule-group"
      sampled_requests_enabled   = true
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-alb-waf"
    sampled_requests_enabled   = true
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-alb-waf"
    }
  )
}


#---------------------------------------------------------------
# ASSOCIATE WAF WITH ALB
#---------------------------------------------------------------

resource "aws_wafv2_web_acl_association" "alb_waf_association" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
}
