#EC2 data
output "instance_arn" {
  value       = [for i in aws_instance.web_server[*]: i.arn]
  description = "The arn of the web_server instances."
}

output "instance_public_ip" {
  value       = [for i in aws_instance.web_server[*]: i.public_ip]
  description = "The private IP addresses of the web_server instances."
}


#SG outputs
output "sg_id" {
  value       = aws_security_group.allow_http.id
  description = "The private IP address of the main server instance."
}

output "sg_name" {
  value       = aws_security_group.allow_http.name
  description = "The private IP address of the main server instance."
}