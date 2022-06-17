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
