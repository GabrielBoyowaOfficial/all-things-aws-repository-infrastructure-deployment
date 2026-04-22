


#---------------------------------------------------------------
# VARIABLE FILE FOR SG MODULE
#---------------------------------------------------------------

variable "project_name" {}

variable "resource_tags" {
  type = map(string)
}

variable "vpc_id" {}

variable "app_port" {
  default = 80
}

variable "db_port" {
  default = 3306
}
