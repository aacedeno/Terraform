terraform {
  required_providers {
    docker = {
      source  = "terraform-providers/docker"
      version = "~> 2.7.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest" #actual name of image we found on docker hub
}

#Creating a random combination of characters to give unique suffix to the 1st container
resource "random_string" "random" {
  count   = 2 #makes 2 random_string resource
  length  = 4
  special = false
  upper   = false
}

#name is a logiclly value in this instance, just need to use it for referecning
resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.random[count.index].result]) #using join function to assign the random characters to container
  image = docker_image.nodered_image.latest                                #Image needs to be referenced the image resource
  ports {
    internal = 1880
    # external = 1880
  }

}

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