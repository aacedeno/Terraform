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
  length  = 4
  special = false
  upper   = false
}

#Creating a random combination of characters to give unique suffix to the 2nd container
resource "random_string" "random2" {
  length  = 4
  special = false
  upper   = false
}

#name is a logiclly value in this instance, just need to use it for referecning
resource "docker_container" "nodered_container" {
  name  = join("-", ["nodered", random_string.random.result]) #using join function to assign the random characters to container
  image = docker_image.nodered_image.latest                   #Image needs to be referenced the image resource
  ports {
    internal = 1880
    # external = 1880
  }

}
resource "docker_container" "nodered_container2" {
  name = join("-", ["nodered2", random_string.random2.result])            
  image = docker_image.nodered_image.latest 
  ports {
    internal = 1880
    # external = 1880
  }
}

#1st container ouput
output "IP-Address" {
  value       = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
  description = "The IP address and external port of the container"
}

#1st container output
output "Container-Name" {
  value       = docker_container.nodered_container.name
  description = "The name of the container"
}

#2nd container output
output "IP-Address2" {
  value       = join(":", [docker_container.nodered_container2.ip_address, docker_container.nodered_container2.ports[0].external])
  description = "The IP address and external port of the container"
}

#2nd container output 
output "Container-Name2" {
  value       = docker_container.nodered_container2.name
  description = "The name of the container"
}