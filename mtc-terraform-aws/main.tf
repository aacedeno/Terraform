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
  db_subnet_group  = true
}

module "database" {
  source = "./database"
  db_storage = 10
  db_engine_version = "8.0.30"
  db_instance_class = "db.t2.micro"
  db_name = var.db_name 
  dbuser = var.dbuser 
  dbpassword = var.dbpassword 
  db_identifier = "aac-db"
  skip_db_snapshot = true   #In prod it should most liekly be set to false
  db_subnet_group_name = module.networking.aws_db_subnet_group_name[0]  #Use count index to specify 1 private subent for db instance
  vpc_security_group_ids = module.networking.db_security_group
}

module "loadbalancing" {
  source                 = "./loadbalancing"
  public_sg              = module.networking.public_sg
  public_subnets         = module.networking.public_subnets
  tg_port                = 80
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 80   
  listener_protocol      = "HTTP"
}

module "compute" {
  source          = "./compute"
  public_sg       = module.networking.public_sg
  public_subnets  = module.networking.public_subnets
  instance_count  = 2
  instance_type   = "t3.micro"
  vol_size        = 10
  key_name        = "keyaac"
  public_key_path = "/home/ec2-user/.ssh/keyaac.pub"
  user_data_path = "${path.root}/userdata.tpl"
  db_name = var.db_name 
  dbuser = var.dbuser 
  dbpassword = var.dbpassword 
  db_endpoint = module.database.db_endpoint
  lb_target_group_arn = module.loadbalancing.lb_target_group_arn
  tg_port = 8000
  
}