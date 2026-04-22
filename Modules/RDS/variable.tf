


#---------------------------------------------------------------
# VARIABLE FILE FOR RDS MODULE
#---------------------------------------------------------------

variable "project_name" {}

variable "resource_tags" {
  type = map(string)
}

variable "DB_private_subnet_1_id" {}

variable "DB_private_subnet_2_id" {}

variable "rds_sg_id" {}

variable "database_name" {}

variable "master_username" {}

variable "master_password" {
  sensitive = true
}

variable "engine_version" {
  default = "8.0.mysql_aurora.3.05.2"
}

variable "instance_class" {
  default = "db.t3.medium"
}

variable "backup_retention_period" {
  default = 7
}
