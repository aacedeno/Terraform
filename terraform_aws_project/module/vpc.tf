#Parsing the Default VPC into Terraform
data "aws_vpc" "default" {
  default = true
}

#Creating 3 new subnets in the Default VPC
resource "aws_default_subnet" "public_subnets" {
  count             = 3
  # vpc_id            = data.aws_vpc.default.id
  # cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index) #Element allows us to cycle through a list using an index
  force_destroy =     "true"
  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

# resource "aws_subnet" "public_subnets" {
#   count             = length(var.public_subnet_cidrs)
#   vpc_id            = data.aws_vpc.default.id
#   cidr_block        = element(var.public_subnet_cidrs, count.index)
#   availability_zone = element(var.azs, count.index) #Element allows us to cycle through a list using an index
#   tags = {
#     Name = "Public Subnet ${count.index + 1}"
#   }
# }

