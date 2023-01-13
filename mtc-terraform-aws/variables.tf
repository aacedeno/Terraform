#-------- root/variables---------
variable "aws_region" {
  default = "us-west-2" #has 4 AZs
}
variable "access_ip" {
  type = string
}