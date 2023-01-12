#all the metaadata about our deployment in this map

locals {
  deployment = {
    nodered = {                                                              #Keys
      container_count = length(var.ext_port["nodered"][terraform.workspace]) #Amount of ports control the amount of images and containers created
      image           = var.image["nodered"][terraform.workspace]            #Value
      int             = 1880
      ext             = var.ext_port["nodered"][terraform.workspace]
      container_path  = "/data"
    }
    influxdb = {
      container_count = length(var.ext_port["influxdb"][terraform.workspace])
      image           = var.image["influxdb"][terraform.workspace]
      int             = 8086
      ext             = var.ext_port["influxdb"][terraform.workspace]
      container_path  = "/var/lib/influxdb" #Found info a influxdb registry docs
    }
    grafana = {
      container_count = length(var.ext_port["grafana"][terraform.workspace])
      image           = var.image["grafana"][terraform.workspace]
      int             = 3000
      ext             = var.ext_port["grafana"][terraform.workspace]
      container_path  = "/var/lib/grafana" #Found info a influxdb registry docs
    }
  }
}
