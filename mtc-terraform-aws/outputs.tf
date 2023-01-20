#---root/outputs.tf ---

#This output is taken from an output in the loadbalancing outputs.tfs
output "load-balancer_endpoint" {
    value = module.loadbalancing.lb_endpoint
}

#Referecning the output "instance" here
output "instances" {
    value = {for i in module.compute.instance : i.tags.Name => "${i.public_ip}:${module.compute.instance_port}"}
    sensitive = true
}
