data "vsphere_virtual_machine" "controller_template" {
  name          = "controller-${var.controller["version"]}-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}
#
resource "vsphere_virtual_machine" "controller" {
  count            = var.controller["count"]
  name             = "controller-${var.controller["version"]}-${count.index}"
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  folder           = vsphere_folder.folder.path

  network_interface {
    network_id = data.vsphere_network.networks[count.index].id
  }

  num_cpus                   = var.controller["cpu"]
  memory                     = var.controller["memory"]
  wait_for_guest_net_timeout = var.controller["wait_for_guest_net_timeout"]

  guest_id              = data.vsphere_virtual_machine.controller_template.guest_id
  scsi_type             = data.vsphere_virtual_machine.controller_template.scsi_type
  scsi_bus_sharing      = data.vsphere_virtual_machine.controller_template.scsi_bus_sharing
  scsi_controller_count = data.vsphere_virtual_machine.controller_template.scsi_controller_scan_count

  disk {
    size             = var.controller["disk"]
    label            = "controller-${var.controller["version"]}-${count.index}.lab_vmdk"
    eagerly_scrub    = data.vsphere_virtual_machine.controller_template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.controller_template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.controller_template.id
  }

  vapp {
    properties = {
      "mgmt-ip"    = element(var.controller.mgmt_ips, count.index)
      "mgmt-mask"  = element(var.controller.mgmt_masks, count.index)
      "default-gw" = element(var.controller.default_gws, count.index)
    }
  }

}
