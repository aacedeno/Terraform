#---container-module

#name is a logiclly value in this instance, just need to use it for referecning
resource "docker_container" "nodered_container" {
  name  = var.name_in
  image = var.image_in                                                               #Image needs to be referenced the image resource
  ports {
    internal = var.int_port_in
    external = var.ext_port_in
    #allows us to access all the elements in the list based on the # of iterations we've been thorugh 
  }
  volumes {
    container_path = var.container_path_in                 #nodered docs said mount it to the data volume  
    host_path      = var.host_path_in

}
}