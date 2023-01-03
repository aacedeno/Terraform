#EC2 data
output "instance_arn" {
  value       = [for i in aws_instance.web_server[*] : i.arn]
  description = "The arn of the web_server instances."
}

output "instance_public_ip" {
  value       = [for i in aws_instance.web_server[*] : i.public_ip]
  description = "The private IP addresses of the web_server instances."
}

#VPC data
#Join these 2 outputs later
output "subnet_id_range" {
  value = [for i in aws_default_subnet.public_subnets[*] : i.availability_zone_id]
  description = "CIDR ranges for each subnet" 
}

output "subnet_cidr_range" {
  value = [for i in aws_default_subnet.public_subnets[*] : i.cidr_block]
  description = "CIDR ranges for each subnet" 
}