#------ networking/outputs.tf --------

output "vpc_id" {
  value = aws_vpc.aac_vpc.id
}

output "aws_db_subnet_group_name" {
  value = aws_db_subnet_group.aac_rds_subnetgroup.*.name #Outputs every private subnet
}

output "db_security_group" {
  value = [aws_security_group.aac_sg["rds"].id] #Using rds key name to return its values
}

#--- ALB ---

output "public_sg" {
  value = [aws_security_group.aac_sg["public"].id]
}

output "public_subnets" {
  value = aws_subnet.aac_public_subnet.*.id
}