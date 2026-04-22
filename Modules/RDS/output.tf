


#---------------------------------------------------------------
# OUTPUT FILE FOR RDS MODULE
#---------------------------------------------------------------

output "cluster_endpoint" {
  value = aws_rds_cluster.aurora_cluster.endpoint
}

output "cluster_reader_endpoint" {
  value = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "cluster_identifier" {
  value = aws_rds_cluster.aurora_cluster.cluster_identifier
}

output "database_name" {
  value = aws_rds_cluster.aurora_cluster.database_name
}

output "aurora_instance_1_id" {
  value = aws_rds_cluster_instance.aurora_instance_1.id
}

output "aurora_instance_2_id" {
  value = aws_rds_cluster_instance.aurora_instance_2.id
}

output "resource_tags" {
  value = var.resource_tags
}
