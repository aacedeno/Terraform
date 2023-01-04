#---root-module
resource "null_resource" "dockervol1" {
  provisioner "local-exec" {
    command = "mkdir noderedvol1/ || true && sudo chown -R 1000:1000 noderedvol1/"
  }
}

module "image" {
  source   = "./image"
  image_in = var.image[terraform.workspace] #This will access the key in the image map that coresponds to terraform workspace 
}

#Creating a random combination of characters to give unique suffix to the 1st container
resource "random_string" "random" {
  count   = local.container_count #makes 2 random_string resource
  length  = 4
  special = false
  upper   = false
}

#name is a logiclly value in this instance, just need to use it for referecning
module "container" {
  source = "./container"
  depends_on = [null_resource.dockervol1.id]
  count = local.container_count
  name_in  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result]) #using join function to assign the random characters to container
  image_in = module.image.image_out                                                                #Image needs to be referenced the image resource
  int_port_in = var.int_port
  ext_port_in = var.ext_port[terraform.workspace][count.index] #running count.index on the entire function 
  #allows us to access all the elements in the list based on the # of iterations we've been thorugh 
  container_path_in = "/data"                   #nodered docs said mount it to the data volume  
  host_path_in      = "${path.cwd}/noderedvol1" #file path to volume


}


