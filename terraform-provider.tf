provider "openstack" {
}

data "openstack_compute_flavor_v2" "master" {
    vcpus = 2
    ram = 4096
}

data "openstack_compute_flavor_v2" "node" {
    vcpus = 2
    ram = 4096
}

data "openstack_images_image_v2" "master" {
  name = "Ubuntu 18.04"
  most_recent = true
}

data "openstack_images_image_v2" "node" {
  name = "Ubuntu 18.04"
  most_recent = true
}

data "openstack_networking_network_v2" "public" {
  name = "public-belwue"
}

data "openstack_compute_keypair_v2" "kp" {
  name = "Smartcard"
}