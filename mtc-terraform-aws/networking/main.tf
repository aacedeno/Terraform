#------networking/main.tf ------

#This random integer will allow us to assign a new number to our vpc
resource "random_integer" "random" {
    min = 1 
    max = 100
}

resource "aws_vpc" "aac_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true     #Provide a dns hostname for any reosurce that is deployed in a public env
    enable_dns_support = true
    
    tags = {
        Name = "aac_vpc-${random_integer.random.id}"
    }
}

resource "aws_subnet" "aac_public_subnet" {
    count = length(var.public_cidrs) #Creates the exact amount of CIDR ranges 
    vpc_id = aws_vpc.aac_vpc.id
    cidr_block = var.public_cidrs[count.index]
    map_public_ip_on_launch = true
    availability_zone = ["us-west-2a", "us-west-2b", "us-west-2c", "us=west2d"][count.index]
    
    tags = {
        Name = "aac_public_${count.index + 1}"  #Common tag naming 
    }
}

resource "aws_subnet" "aac_private_subnet" {
    count = length(var.private_cidrs)
    vpc_id = aws_vpc.aac_vpc.id
    cidr_block = var.private_cidrs[count.index]
    availability_zone = ["us-west-2a", "us-west-2b", "us-west-2c", "us=west2d"][count.index]
    
    tags = {
        Name = "aac_private_${count.index + 1}" 
    }
}