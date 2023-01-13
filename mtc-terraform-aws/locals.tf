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
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}