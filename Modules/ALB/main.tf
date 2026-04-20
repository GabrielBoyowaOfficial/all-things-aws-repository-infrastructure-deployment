


#---------------------------------------------------------------
## This is the ALB resource file for my module
#---------------------------------------------------------------

resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.alb_logs_bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }

  depends_on = [aws_s3_bucket_policy.alb_logs_bucket_policy_attachment]

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-alb"
    }
  )
}


#---------------------------------------------------------------
# TARGET GROUP
#---------------------------------------------------------------

resource "aws_lb_target_group" "target_group" {
  name        = "${var.project_name}-tg"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = var.target_group_protocol
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-tg"
    }
  )
}


#---------------------------------------------------------------
# ALB LISTENER - HTTP PORT 80
#---------------------------------------------------------------

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-http-listener"
    }
  )
}
