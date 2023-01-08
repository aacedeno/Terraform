#---container-module


resource "random_string" "random" {
  count = var.count_in
  length  = 4
  special = false
  upper   = false
}


#name is a logiclly value in this instance, just need to use it for referecning
resource "docker_container" "app_container" {
  count = var.count_in
  name  = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result])
  image = var.image_in              #Image needs to be referenced the image resource
  ports {
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
    #allows us to access all the elements in the list based on the # of iterations we've been thorugh 
  }
  volumes {
    container_path = var.container_path_in                 #nodered docs said mount it to the data volume  
    volume_name = docker_volume.container_volume[count.index].name
  }
}
  
resource "docker_volume" "container_volume" {
    count = var.count_in
    name = "${var.name_in}-${random_string.random[count.index].result}-volume"
    lifecycle {
      prevent_destroy = false
    }
  }
  
