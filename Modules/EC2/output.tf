


#---------------------------------------------------------------
# OUTPUT FILE FOR EC2 MODULE
#---------------------------------------------------------------

output "asg_name" {
  value = aws_autoscaling_group.ec2_asg.name
}

output "asg_arn" {
  value = aws_autoscaling_group.ec2_asg.arn
}

output "launch_template_id" {
  value = aws_launch_template.ec2_launch_template.id
}

output "launch_template_latest_version" {
  value = aws_launch_template.ec2_launch_template.latest_version
}

output "resource_tags" {
  value = var.resource_tags
}
