variable "auth_url" {}
variable "tenant_name" {}
variable "tenant_id" {}
variable "username" {}
variable "password" {}
variable "key_path" {}
variable "public_key_path" {}
variable "floating_ip_pool" {}
variable "network_external_id" {}
variable "region" {
  default = "RegionOne"
}

variable "network" {
	default = "192.168"
}

variable "image_name" {
  default = "ubuntu-14.04"
}





variable "dns1" {
  default = "8.8.4.4"
}

variable "dns2" {
  default = "8.8.8.8"
}
