#Outputs the name for all nodered_containers created 
output "container-name" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the container"
}

#Outputs the IP address and external ports for each nodered_container created
output "ip-address" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The IP address and external port of the container"
}
