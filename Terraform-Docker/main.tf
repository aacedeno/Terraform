terraform {
  required_providers {
    docker = {
      source  = "terraform-providers/docker"
      version = "~> 2.7.2"
    }
  }
}

provider "docker" {}

resource "null_resource" "dockervol1" {
  provisioner "local-exec" {
    command = "mkdir noderedvol1/ || true && sudo chown -R 1000:1000 noderedvol1/"
  }
}

resource "docker_image" "nodered_image" {
  name = var.image[terraform.workspace] #Looks up image of map baesd on the env var
}

#Creating a random combination of characters to give unique suffix to the 1st container
resource "random_string" "random" {
  count   = local.container_count #makes 2 random_string resource
  length  = 4
  special = false
  upper   = false
}

#name is a logiclly value in this instance, just need to use it for referecning
resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result]) #using join function to assign the random characters to container
  image = docker_image.nodered_image.latest                                #Image needs to be referenced the image resource
  ports {
    internal = var.int_port
    external = var.ext_port[terraform.workspace][count.index] #running count.index on the entire function 
    #allows us to access all the elements in the list based on the # of iterations we've been thorugh 
  }
  volumes {
    container_path = "/data" #nodered docs said mount it to the data volume  
    host_path = "${path.cwd}/noderedvol1" #file path to volume
  }


}

