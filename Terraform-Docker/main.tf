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
  count   = var.container_count #makes 2 random_string resource
  length  = 4
  special = false
  upper   = false
}

#name is a logiclly value in this instance, just need to use it for referecning
resource "docker_container" "nodered_container" {
  count = var.container_count
  name  = join("-", ["nodered", random_string.random[count.index].result]) #using join function to assign the random characters to container
  image = docker_image.nodered_image.latest                                #Image needs to be referenced the image resource
  ports {
    internal = var.int_port
    external = var.ext_port
  }

}

