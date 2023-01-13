#-----Creating VPC-------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" #Figure out CIDR range 


  tags = {
    Name = "main"
  }
}

#-----Public subnet--------
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

#-------Private Subnet -------
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

#-------IGW------
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}
