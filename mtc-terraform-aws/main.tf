#-----root/main.tf ---



module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  private_sn_count = 3
  max_subnets      = 20
  public_sn_count  = 2
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)] #Use even number for public 
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)] #Use odd numbers for private

}
