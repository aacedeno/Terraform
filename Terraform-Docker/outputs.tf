#Outputs the name for all nodered_containers created 
output "container-name" {
  value       = module.container[*].container-name
  description = "The name of the container"
}

# #Outputs the IP address and external ports for each nodered_container created
output "ip-address" {
  value       = flatten(module.container[*].ip-address)
  description = "The IP address and external port of the container"
}
