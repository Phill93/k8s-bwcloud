resource "openstack_compute_instance_v2" "ingress" {
    name            = "ingress"
    image_id        = "${data.openstack_images_image_v2.ingress.id}"
    flavor_id       = "${data.openstack_compute_flavor_v2.ingress.id}"
    key_pair        = "${data.openstack_compute_keypair_v2.kp.name}"
    security_groups = [
        "${openstack_networking_secgroup_v2.sec_egress.name}",
        "${openstack_networking_secgroup_v2.sec_ssh.name}",
        "${openstack_networking_secgroup_v2.sec_node.name}",
        "${openstack_networking_secgroup_v2.sec_http.name}"
        ]
    depends_on = [openstack_networking_subnet_v2.k8s-cluster]
    config_drive = true

    network {
        name = "${data.openstack_networking_network_v2.public.name}"
    }

    network {
        name = "${openstack_networking_network_v2.clusternetwork.name}"
    }
}
