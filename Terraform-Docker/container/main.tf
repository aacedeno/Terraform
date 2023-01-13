#---container-module ---------

resource "random_string" "random" {
  count   = var.count_in
  length  = 4
  special = false
  upper   = false
}


#name is a logiclly value in this instance, just need to use it for referecning
resource "docker_container" "app_container" {
  count = var.count_in
  name  = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result])
  image = var.image_in #Image needs to be referenced the image resource
  ports {
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
    #allows us to access all the elements in the list based on the # of iterations we've been thorugh 
  }
  volumes {
    container_path = var.container_path_in #nodered docs said mount it to the data volume  
    volume_name    = docker_volume.container_volume[count.index].name
  }
  provisioner "local-exec" {
    command = "echo ${self.name}: ${self.ip_address}:${join("", [for x in self.ports[*]["external"] : x])} >> container.txt"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f containers.txt"
  }
}

resource "docker_volume" "container_volume" {
  count = var.count_in
  name  = "${var.name_in}-${random_string.random[count.index].result}-volume" #Can reference this argument in provisioner
  lifecycle {
    prevent_destroy = false
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "mkdir ${path.cwd}/../backup/" #Send the backup a directory up since I don't want to store all my backups in the code I'll be commiting to repo
    on_failure = continue
  }
  provisioner "local-exec" {
    when    = destroy
    command = "sudo tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/" #Using tar to compress our volume(self.mountpoint) into the backup folder and name it after the volume
  }
}
  