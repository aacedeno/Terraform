#------networking/main.tf ------

data "aws_availability_zones" "available" {}

#This random integer will allow us to assign a new number to our vpc
resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets #This is producing a list that is stored in the state 
}

resource "aws_vpc" "aac_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true #Provide a dns hostname for any reosurce that is deployed in a public env
  enable_dns_support   = true

  tags = {
    Name = "aac_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "aac_public_subnet" {
  count                   = var.public_sn_count #Creates the exact amount of CIDR ranges 
  vpc_id                  = aws_vpc.aac_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "aac_public_${count.index + 1}" #Common tag naming 
  }
}

#Have to connect the public route table  to the public subnet
resource "aws_route_table_association" "aac_public_assoc" {
  count          = var.public_sn_count                            #Need to associate every public subnet to public route table  
  subnet_id      = aws_subnet.aac_public_subnet.*.id[count.index] #Can access each subnet after each iteration 
  route_table_id = aws_route_table.aac_public_rt.id
}

resource "aws_subnet" "aac_private_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.aac_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "aac_private_${count.index + 1}"
  }
}

#Can only have 1 IGW per VPC
resource "aws_internet_gateway" "aac_internet_gateway" {
  vpc_id = aws_vpc.aac_vpc.id

  tags = {
    Name = "aac_igw"
  }
}

resource "aws_route_table" "aac_public_rt" {
  vpc_id = aws_vpc.aac_vpc.id

  tags = {
    Name = "aac_public"
  }
}

#Deafult route is where all traffic goes that isn't destined for somthing, IGW will be default route
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.aac_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aac_internet_gateway.id
}

#Deafult route table is the route table the subnets used if they haven't been explicity assigned to one 
resource "aws_default_route_table" "aac_private_rt" {
  default_route_table_id = aws_vpc.aac_vpc.default_route_table_id #Every VPC gets a default route table, I'm specifying the default route created by the vpc is going to be the default route table for infra

  tags = {
    Name = "aac_private"
  }

}


resource "aws_security_group" "aac_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.aac_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "aac_rds_subnetgroup" {
  count      = var.db_subnet_group == true ? 1 : 0 #Checks if variable is true and deploys 1 subnet group if true
  name       = "aac_rds_subnetgroup"
  subnet_ids = aws_subnet.aac_private_subnet.*.id #Any private subnet can be used 
  tags = {
    Name = "aac_rds_sng"
  }
}