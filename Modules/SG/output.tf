


#---------------------------------------------------------------
# OUTPUT FILE FOR SG MODULE
#---------------------------------------------------------------

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "resource_tags" {
  value = var.resource_tags
}
