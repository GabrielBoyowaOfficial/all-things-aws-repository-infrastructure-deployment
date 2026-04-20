


#---------------------------------------------------------------
# VARIABLE FILE FOR ALB MODULE
#---------------------------------------------------------------

variable "project_name" {}

variable "resource_tags" {
  type = map(string)
}

variable "vpc_id" {}

variable "public_subnet_1_id" {}

variable "public_subnet_2_id" {}

variable "alb_security_group_id" {}

variable "target_group_port" {
  default = 80
}

variable "target_group_protocol" {
  default = "HTTP"
}

variable "health_check_path" {
  default = "/"
}

variable "alb_logs_bucket" {}

variable "waf_logs_bucket" {}
