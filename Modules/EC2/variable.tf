


#---------------------------------------------------------------
# VARIABLE FILE FOR EC2 MODULE
#---------------------------------------------------------------

variable "project_name" {}

variable "resource_tags" {
  type = map(string)
}

variable "ami_id" {}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {}

variable "ec2_sg_id" {}

variable "private_subnet_1_id" {}

variable "private_subnet_2_id" {}

variable "target_group_arn" {}

variable "app_port" {
  default = 80
}

variable "root_volume_size" {
  default = 20
}

variable "user_data" {
  default = null
}

variable "asg_min_size" {
  default = 1
}

variable "asg_desired_capacity" {
  default = 2
}

variable "asg_max_size" {
  default = 6
}
