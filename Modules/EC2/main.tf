


#---------------------------------------------------------------
## This is the EC2 resource file for my module
#---------------------------------------------------------------


#---------------------------------------------------------------
# LAUNCH TEMPLATE - defines instance configuration for the ASG
#---------------------------------------------------------------

resource "aws_launch_template" "ec2_launch_template" {
  name          = "${var.project_name}-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data != null ? base64encode(var.user_data) : null

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.ec2_sg_id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.resource_tags,
      {
        Name = "${var.project_name}-asg-instance"
      }
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      var.resource_tags,
      {
        Name = "${var.project_name}-asg-volume"
      }
    )
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-launch-template"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}


#---------------------------------------------------------------
# AUTO SCALING GROUP - min 1, desired 2, max 6
#---------------------------------------------------------------

resource "aws_autoscaling_group" "ec2_asg" {
  name                = "${var.project_name}-asg"
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  vpc_zone_identifier = [var.private_subnet_1_id, var.private_subnet_2_id]
  target_group_arns   = [var.target_group_arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = merge(
      var.resource_tags,
      {
        Name = "${var.project_name}-asg"
      }
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
