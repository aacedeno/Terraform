#---root-module


module "image" {
  source   = "./image"
  for_each = local.deployment #This allows us to access all of our keys and value using the each keyword
  image_in = each.value.image
}

#Creating a random combination of characters to give unique suffix to the 1st container


module "container" {
  source      = "./container"
  count_in    = each.value.container_count
  for_each    = local.deployment
  name_in     = each.key                         #using join function to assign the random characters to container
  image_in    = module.image[each.key].image_out #Image needs to be referenced the image resource
  int_port_in = each.value.int
  ext_port_in = each.value.ext
  #allows us to access all the elements in the list based on the # of iterations we've been thorugh 
  container_path_in = each.value.container_path #nodered docs said mount it to the data volume  


}


