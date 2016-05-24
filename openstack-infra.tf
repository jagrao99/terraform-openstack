provider "openstack" {
  auth_url = "${var.auth_url}"
  tenant_name = "${var.tenant_name}"
  user_name = "${var.username}"
  password = "${var.password}"
}

resource "openstack_networking_network_v2" "antarjal_net" {
  region = "${var.region}"
  name = "antarjal-net"
  admin_state_up = "true"
  tenant_id = "${var.tenant_id}"
}

resource "openstack_networking_subnet_v2" "antarjal_subnet" {
  name = "antarjal-subnet"
  region = "${var.region}"
  network_id = "${openstack_networking_network_v2.antarjal_net.id}"
  cidr = "${var.network}.1.0/24"
  ip_version = 4
  tenant_id = "${var.tenant_id}"
}

resource "openstack_networking_router_v2" "router" {
  name = "router"
  region = "${var.region}"
  admin_state_up = "true"
  external_gateway = "${var.network_external_id}"
  tenant_id = "${var.tenant_id}"
}

resource "openstack_compute_secgroup_v2" "jumphost" {
  name = "bastion-${var.tenant_name}"
  description = "Bastion Security groups"
  region = "${var.region}"

  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }


  resource "openstack_networking_floatingip_v2" "jumphost_fp" {
  region = "${var.region}"
  pool = "${var.floating_ip_pool}"
}


resource "openstack_compute_instance_v2" "jumphost" {
  name = "jumphost"
  image_name = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  region = "${var.region}"
  key_pair = "${openstack_compute_keypair_v2.keypair.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.jumphost.name}" ]
  floating_ip = "${openstack_networking_floatingip_v2.jumphost_fp.address}"

  network {
    uuid = "${openstack_networking_network_v2.antarjal_net.id}"
  }

}

}
