#Can use 2 different resources for security group aws_security_group and 
#aws_security_group_rule

#Terraform defaults to the region's default VPC if none is specified 
#Terraform defaults to the region's default VPC if none is specified 
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  #Use .tfvars to put my own ip for SSH
  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #Equivalent to "all/any"
    cidr_blocks = var.cidr_blocks
  }
  tags = {
    Name = "allow_http"
  }
}