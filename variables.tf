variable "vsphere_user" {
  type = string
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_server" {
  type = string
}

variable "datacenter" {
  type = string
}

variable "cluster" {
  type = string
}

variable "datastore" {
  type = string
}

variable "datastore_url" {
  type = string
}

variable "vm_folder" {
  type = string
}

variable "resource_pool" {
  type = string
}

variable "network" {
  type = string
}

variable "ubuntu_template" {
  type = string
}

variable "http_proxy_host" {
  type    = string
  default = ""
}

variable "http_proxy_port" {
  type    = number
  default = 0
}

variable "mgt_control_plane_endpoint" {
  type = string
}

variable "wkl_control_plane_endpoint" {
  type = string
}

variable "customerconnect_user" {
  type = string
}

variable "customerconnect_pass" {
  type = string
}


variable "avi_ova_name" {
  type = string
}
variable "avi_ip" {
  type = string
}
variable "avi_controller" {
  type = string
}
variable "avi_controller_network_mask" {
  type = string
}
variable "avi_controller_network_gateway" {
  type = string
}
variable "avi_username" {
  type = string
}
variable "avi_password" {
  type = string
}
variable "avi_cloud_name" {
  type = string
}
variable "avi_service_engine_group" {
  type = string
}
variable "avi_data_network" {
  type = string
}
variable "avi_data_network_cidr" {
  type = string
}
variable "avi_ca_data_b64" {
  type = string
}
