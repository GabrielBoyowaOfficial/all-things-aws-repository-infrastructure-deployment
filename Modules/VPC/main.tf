


#---------------------------------------------------------------
## This is the VPC resource file for my module
#---------------------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = merge(

    var.resource_tags,

    {
      Name = "${var.project_name}-vpc"
    }
  )
}

#---------------------------------------------------------------
# INTERNET GATEWAY
#---------------------------------------------------------------
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

data "aws_availability_zones" "availability_zones" {}


#---------------------------------------------------------------
# PUBLIC SUBNETS
#---------------------------------------------------------------
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_2_cidr_block
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}


#---------------------------------------------------------------
# PUBLIC SUBNETS ROUTE TABLE
#---------------------------------------------------------------

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public-RT"
  }
}



#---------------------------------------------------------------
# ROUTE TRAFFIC TO IPUBLIC NTERNET 
#---------------------------------------------------------------
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}



#---------------------------------------------------------------
# ASSOCIATE PUBLIC SUBNETS TO ROUTE TABLE
#---------------------------------------------------------------

resource "aws_route_table_association" "public_subnet_association-1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association-2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}


#---------------------------------------------------------------
# ELASTIC IP FOR NAT GATEWAY
#---------------------------------------------------------------

resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-nat-eip"
    }
  )
}


#---------------------------------------------------------------
# NAT GATEWAY - sits in public subnet 1
#---------------------------------------------------------------

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-nat-gw"
    }
  )

  depends_on = [aws_internet_gateway.internet_gateway]
}


#---------------------------------------------------------------
# PRIVATE SUBNETS ROUTE TABLE
#---------------------------------------------------------------

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-RT"
  }
}


#---------------------------------------------------------------
# ROUTE PRIVATE TRAFFIC THROUGH NAT GATEWAY
#---------------------------------------------------------------

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}


#---------------------------------------------------------------
# ASSOCIATE PRIVATE SUBNETS TO PRIVATE ROUTE TABLE
#---------------------------------------------------------------

resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}


#---------------------------------------------------------------
# PRIVATE SUBNETS
#---------------------------------------------------------------

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_1_cidr_block
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_2_cidr_block
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-2"
  }
}


#---------------------------------------------------------------
# DATABASE SUBNETS
#---------------------------------------------------------------

resource "aws_subnet" "DB_private_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.DB_private_subnet_1_cidr_block
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "DB-private-subnet-1"
  }
}

resource "aws_subnet" "DB_private_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.DB_private_subnet_2_cidr_block
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "DB-private-subnet-2"
  }
}

