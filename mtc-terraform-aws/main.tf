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
  db_subnet_group = true
}

module "database" {
  source = "./database"
  db_storage = 10
  db_engine_version = "5.7.22"
  db_instance_class = "db.t2.micro"
  db_name = "rancher"
  dbuser = "bobby"
  dbpassword = "baers2237"
  db_identifier = "aac-db"
  skip_db_snapshot = true   #In prod it should most liekly be set to false
  db_subnet_group_name = module.networking.aws_db_subnet_group_name[0]  #Use count index to specify 1 private subent for db instance
  vpc_security_group_ids = module.networking.db_security_group

}