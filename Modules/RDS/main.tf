


#---------------------------------------------------------------
## This is the RDS Aurora resource file for my module
#---------------------------------------------------------------


#---------------------------------------------------------------
# DB SUBNET GROUP - uses dedicated DB private subnets
#---------------------------------------------------------------

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = [var.DB_private_subnet_1_id, var.DB_private_subnet_2_id]

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-rds-subnet-group"
    }
  )
}


#---------------------------------------------------------------
# AURORA CLUSTER
#---------------------------------------------------------------

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "${var.project_name}-aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.rds_sg_id]
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = true
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = "02:00-03:00"

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-aurora-cluster"
    }
  )
}


#---------------------------------------------------------------
# AURORA CLUSTER INSTANCE - AZ 1
#---------------------------------------------------------------

resource "aws_rds_cluster_instance" "aurora_instance_1" {
  identifier         = "${var.project_name}-aurora-instance-1"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-aurora-instance-1"
    }
  )
}


#---------------------------------------------------------------
# AURORA CLUSTER INSTANCE - AZ 2
#---------------------------------------------------------------

resource "aws_rds_cluster_instance" "aurora_instance_2" {
  identifier         = "${var.project_name}-aurora-instance-2"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-aurora-instance-2"
    }
  )
}
