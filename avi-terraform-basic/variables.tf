variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
#
# Other Variables
#
variable "vcenter" {
  type = map
  default = {
    dc = "DC-1"
    cluster = "TKG"
    datastore = "Datastore"
    resource_pool = "Resource"
    folder = "avi-2"
  }
}

variable "controller" {
  default = {
    cpu = 8
    memory = 24768
    disk = 128
    count = "1"
    version = "20.1.1-9071"
    wait_for_guest_net_timeout = 2
    networks = ["avi-lb"]
    mgmt_ips = ["10.6.0.20"]
    mgmt_masks = ["255.255.255.0"]
    default_gws = ["10.6.0.1"]
  }
}
