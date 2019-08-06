resource "openstack_networking_network_v2" "clusternetwork" {
  name           = "k8s-cluster"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "k8s-cluster" {
  network_id = "${openstack_networking_network_v2.clusternetwork.id}"
  cidr = "10.0.0.0/24"
  no_gateway = true
}

resource "openstack_networking_secgroup_v2" "sec_egress" {
  name        = "Egress"
  description = "Security Group for egress traffic"
  delete_default_rules = false
}

resource "openstack_networking_secgroup_v2" "sec_ssh" {
  name        = "SSH"
  description = "Security Group for SSH"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "sec_ssh_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.sec_ssh.id}"
}

resource "openstack_networking_secgroup_v2" "sec_master" {
  name        = "K8S Master"
  description = "Security Group for K8S Master Nodes"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "sec_master_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.sec_master.id}"
}

resource "openstack_networking_secgroup_v2" "sec_node" {
  name        = "K8S Nodes"
  description = "Security Group for K8S Nodes"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "sec_nodes_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 4149
  port_range_max    = 4149
  remote_ip_prefix  = "${openstack_networking_subnet_v2.k8s-cluster.cidr}"
  security_group_id = "${openstack_networking_secgroup_v2.sec_node.id}"
  description       = "kublet"
}

resource "openstack_networking_secgroup_rule_v2" "sec_nodes_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = "${openstack_networking_subnet_v2.k8s-cluster.cidr}"
  security_group_id = "${openstack_networking_secgroup_v2.sec_node.id}"
  description       = "kublet"
}

resource "openstack_networking_secgroup_rule_v2" "sec_nodes_rule_3" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10255
  port_range_max    = 10256
  remote_ip_prefix  = "${openstack_networking_subnet_v2.k8s-cluster.cidr}"
  security_group_id = "${openstack_networking_secgroup_v2.sec_node.id}"
  description       = "kublet and kube-proxy"
}

resource "openstack_networking_secgroup_rule_v2" "sec_nodes_rule_4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6783
  port_range_max    = 6783
  remote_ip_prefix  = "${openstack_networking_subnet_v2.k8s-cluster.cidr}"
  security_group_id = "${openstack_networking_secgroup_v2.sec_node.id}"
  description       = "CNI Weave Control Port"
}

resource "openstack_networking_secgroup_rule_v2" "sec_nodes_rule_5" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 6783
  port_range_max    = 6784
  remote_ip_prefix  = "${openstack_networking_subnet_v2.k8s-cluster.cidr}"
  security_group_id = "${openstack_networking_secgroup_v2.sec_node.id}"
  description       = "CNI Weave Data Ports"
}

resource "openstack_networking_secgroup_v2" "sec_etcd" {
  name        = "Etcd"
  description = "Security Group for etcd nodes"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "sec_etcd_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2379
  port_range_max    = 2380
  remote_ip_prefix  = "${openstack_networking_subnet_v2.k8s-cluster.cidr}"
  security_group_id = "${openstack_networking_secgroup_v2.sec_etcd.id}"
  description       = "etcd cluster port"
}