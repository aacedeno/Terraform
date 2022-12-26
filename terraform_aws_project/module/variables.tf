#Ec2 variables

variable "ec2_instance_type" {
  type        = string
  description = "The instance type of the ec2"
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of instances to provision."
  type        = number
  default     = 3
}

variable "ami_id" {
  type        = string
  description = "The ami id of the ec2 in us-east-1"
  default     = "ami-0b5eea76982371e91"
}

variable "user_data_replace" {
  default = true
}

#Webserver sg
variable "cidr_blocks" {
  default = ["0.0.0.0/0"]
}

