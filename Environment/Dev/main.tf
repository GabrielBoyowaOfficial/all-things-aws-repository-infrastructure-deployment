

module "vpc" {
  source                         = "../../Modules/VPC"
  provider_region                = var.provider_region
  project_name                   = var.project_name
  vpc_flow_logs_bucket           = var.vpc_flow_logs_bucket
  resource_tags                  = var.resource_tags
  vpc_cidr_block                 = var.vpc_cidr_block
  public_subnet_1_cidr_block     = var.public_subnet_1_cidr_block
  public_subnet_2_cidr_block     = var.public_subnet_2_cidr_block
  private_subnet_1_cidr_block    = var.private_subnet_1_cidr_block
  private_subnet_2_cidr_block    = var.private_subnet_2_cidr_block
  DB_private_subnet_1_cidr_block = var.DB_private_subnet_1_cidr_block
  DB_private_subnet_2_cidr_block = var.DB_private_subnet_2_cidr_block
}


module "S3" {
  source         = "../../Modules/S3"
  project_name   = module.vpc.project_name
  resource_tags  = module.vpc.resource_tags
  s3_bucket_name = var.s3_bucket_name
}


module "Route-53" {
  source                      = "../../Modules/ROUTE-53"
  project_name                = module.vpc.project_name
  resource_tags               = module.vpc.resource_tags
  dns_query_logs_bucket       = var.dns_query_logs_bucket
  dns_resolver_query_log_name = var.dns_resolver_query_log_name
  vpc_id                      = module.vpc.vpc_id
}


module "SG" {
  source        = "../../Modules/SG"
  project_name  = module.vpc.project_name
  resource_tags = module.vpc.resource_tags
  vpc_id        = module.vpc.vpc_id
  app_port      = var.app_port
}


module "ALB" {
  source                = "../../Modules/ALB"
  project_name          = module.vpc.project_name
  resource_tags         = module.vpc.resource_tags
  vpc_id                = module.vpc.vpc_id
  public_subnet_1_id    = module.vpc.public_subnet_1_id
  public_subnet_2_id    = module.vpc.public_subnet_2_id
  alb_security_group_id = module.SG.alb_sg_id
  alb_logs_bucket       = var.alb_logs_bucket
  waf_logs_bucket       = var.waf_logs_bucket
}


module "RDS" {
  source                  = "../../Modules/RDS"
  project_name            = module.vpc.project_name
  resource_tags           = module.vpc.resource_tags
  DB_private_subnet_1_id  = module.vpc.DB_private_subnet_1_id
  DB_private_subnet_2_id  = module.vpc.DB_private_subnet_2_id
  rds_sg_id               = module.SG.rds_sg_id
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  instance_class          = var.rds_instance_class
}


module "EC2" {
  source              = "../../Modules/EC2"
  project_name        = module.vpc.project_name
  resource_tags       = module.vpc.resource_tags
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  ec2_sg_id           = module.SG.ec2_sg_id
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  target_group_arn    = module.ALB.target_group_arn
  app_port            = var.app_port
  root_volume_size    = var.root_volume_size
  user_data           = file("../../Scripts/user-data/${var.user_data_script}")
}

