


#---------------------------------------------------------------
## This is the Security Group resource file for my module
#---------------------------------------------------------------


#---------------------------------------------------------------
# ALB SECURITY GROUP - HTTP and HTTPS from internet
#---------------------------------------------------------------

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allows HTTP and HTTPS inbound from the internet to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-alb-sg"
    }
  )
}


#---------------------------------------------------------------
# RDS SECURITY GROUP - traffic from EC2 only on db port
#---------------------------------------------------------------

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Allows inbound database traffic from EC2 instances only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow DB traffic from EC2"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-rds-sg"
    }
  )
}


#---------------------------------------------------------------
# EC2 SECURITY GROUP - traffic from ALB only on app port
#---------------------------------------------------------------

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allows inbound traffic from the ALB only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from ALB on app port"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-ec2-sg"
    }
  )
}
