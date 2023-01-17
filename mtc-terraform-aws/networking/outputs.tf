#------ networking/outputs.tf --------

output "vpc_id" {
  value = aws_vpc.aac_vpc.id
<<<<<<< Updated upstream
=======
}

output "aws_db_subnet_group_name" {
    value = aws_db_subnet_group.aac_rds_subnetgroup.*.name      #Outputs every private subnet
}

#It is in brackets because we need the whole list
output "db_security_group" {
    value = [aws_security_group.aac_sg["rds"].id]   #Using rds key name to return its values
>>>>>>> Stashed changes
}