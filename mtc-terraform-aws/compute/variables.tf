#--- compute/variables.tf ---

variable "instance_count" {}
variable "instance_type" {}
variable "vol_size" {}
variable "public_sg" {}
variable "public_subnets" {}
variable "key_name" {}
variable "public_key_path" {} #Private key should never be exposed to anyone
variable "db_endpoint" {}
variable "db_name" {}
variable "dbuser" {}
variable "dbpassword" {}
variable "user_data_path" {}
variable "lb_target_group_arn" {}
variable "tg_port" {}
