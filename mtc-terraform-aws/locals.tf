#------ root/locals.tf------

locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    public = { #Value
      name        = "public_sg"
      description = "SG for public access"
      ingress = {
        open = {
          from        = 0
          to          = 0
          protocol    = -1
          cidr_blocks = [var.access_ip]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        nginx = {
          from = 8000
          to = 8000
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    rds = {
      name        = "database_sg"
      description = "SG for RDS access"
      ingress = {
        rds = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr] #Only want traffic from inside VPC, no external
        }
      }
    }
  }
}


