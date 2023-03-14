terraform {
  required_providers {
    vngcloud = {
      source = "vngcloud/vngcloud"
      version =">= 0.0.17"
    }
  }
}
provider "vngcloud" {
    token_url = "https://iamapis.vngcloud.vn/accounts-api/v2/auth/token"
    client_id = var.client_id
    client_secret = var.client_secret
    vserver_base_url = "https://hcm-3.api.vngcloud.vn/vserver-gateway"
}


data "vngcloud_vserver_volume_type_zone" "volume_type_zone" {
  name       = "SSD"
  project_id = var.project_id
}

data "vngcloud_vserver_volume_type" "volume_type" {
  name                = var.disk_iops
  project_id          = var.project_id
  volume_type_zone_id = data.vngcloud_vserver_volume_type_zone.volume_type_zone.id
}


resource "vngcloud_vserver_server" "server"{
    for_each            = toset(var.server_name)
    project_id          = var.project_id
    name                = each.value
    encryption_volume   = false
    flavor_id           = var.flavor_id["micro"]
    image_id            = var.image_id[each.value]
    network_id          = var.network_id
    attach_floating     = true
    root_disk_size      = 100
    root_disk_type_id   = data.vngcloud_vserver_volume_type.volume_type.id
    user_name           = var.user_name
    user_password       = var.user_password
    ssh_key             = var.ssh_key
    security_group      = [var.security_group["default"], var.security_group["web_server"]]
    subnet_id           = var.subnet_id["localtest"]
    user_data           = file("startup-script")
}
