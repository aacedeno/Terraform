#-------- root/variables---------
variable "aws_region" {
  default = "us-west-2" #has 4 AZs
}
variable "access_ip" {
  type = string
}


#------database variables ---
variable "db_name" {
  type = string
}

variable "dbuser" {
  type = string
  sensitive = true
}

variable "dbpassword" {
  type = string
  sensitive = true
}