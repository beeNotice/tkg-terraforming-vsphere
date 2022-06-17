# Generate TKG configuration.
resource "local_file" "tkg_configuration_file" {
  content = templatefile("tkg-cluster.yml.tpl", {
    vcenter_server   = var.vsphere_server,
    vcenter_user     = var.vsphere_user,
    vcenter_password = var.vsphere_password,
    datacenter       = var.datacenter,
    datastore        = var.datastore,
    network          = var.network,
    resource_pool    = var.resource_pool,
    vm_folder        = var.vm_folder
  })
  filename        = "tkg-cluster.yml"
  file_permission = "0644"
}

resource "local_file" "mgt_configuration_file" {
  content = templatefile("mgmt-cluster-config.yaml.tpl", {
    mgt_control_plane_endpoint   = var.mgt_control_plane_endpoint
  })
  filename        = "mgmt-cluster-config.yaml"
  file_permission = "0644"
}

resource "local_file" "wkl_configuration_file" {
  content = templatefile("dev01-cluster-config.yaml.tpl", {
    wkl_control_plane_endpoint   = var.wkl_control_plane_endpoint
  })
  filename        = "dev01-cluster-config.yaml"
  file_permission = "0644"
}

# Generate additional configuration file.
resource "local_file" "env_file" {
  content = templatefile("env.tpl", {
    http_proxy_host        = var.http_proxy_host,
    http_proxy_port        = var.http_proxy_port
  })
  filename        = "env"
  file_permission = "0644"
}

# Generate govc configuration file.
resource "local_file" "govc_file" {
  content = templatefile("govc.tpl", {
    vsphere_server   = var.vsphere_server,
    vsphere_user     = var.vsphere_user,
    vsphere_password = var.vsphere_password,
    datacenter       = var.datacenter,
    cluster          = var.cluster,
    network          = var.network,
    datastore        = var.datastore,
    resource_pool    = var.resource_pool,
    vm_folder        = var.vm_folder
  })
  filename        = "govc.env"
  file_permission = "0644"
}

# Generate vmd configuration file.
resource "local_file" "vmd_file" {
  content = templatefile("vmd.tpl", {
    customerconnect_user = var.customerconnect_user,
    customerconnect_pass = var.customerconnect_pass
  })
  filename        = "vmd.env"
  file_permission = "0644"
}

# Use the jumpbox to access TKG from the outside.
resource "vsphere_virtual_machine" "jumpbox" {
  name             = "jumpbox"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  # Older versions of VMware tools do not return an IP address:
  # get guest IP address instead.
  wait_for_guest_net_timeout = -1
  wait_for_guest_ip_timeout  = 2

  num_cpus = 2
  memory   = 8192
  guest_id = "ubuntu64Guest"
  folder   = vsphere_folder.vm_folder.path

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    thin_provisioned = true
    size             = 200
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu_template.id

    # Do not include a "customize" section here:
    # this feature is broken with current Ubuntu Cloudimg templates.
  }

  # A CDROM device is required in order to inject configuration properties.
  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      "instance-id" = "jumpbox"
      "hostname"    = "jumpbox"

      # Use our own public SSH key to connect to the VM.
      "public-keys" = file("~/.ssh/id_rsa.pub")
    }
  }

  connection {
    host        = vsphere_virtual_machine.jumpbox.default_ip_address
    timeout     = "30s"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "file" {
    # Copy TKG configuration file.
    source      = "tkg-cluster.yml"
    destination = "/home/ubuntu/tkg-cluster.yml"
  }
  provisioner "file" {
    # Copy TKG mgt configuration file.
    source      = "mgmt-cluster-config.yaml"
    destination = "/home/ubuntu/mgmt-cluster-config.yaml"
  }
  provisioner "file" {
    # Copy TKG wkl configuration file.
    source      = "dev01-cluster-config.yaml"
    destination = "/home/ubuntu/dev01-cluster-config.yaml"
  }
  provisioner "file" {
    # Copy additional configuration file.
    source      = "env"
    destination = "/home/ubuntu/.env"
  }
  provisioner "file" {
    # Copy govc configuration file.
    source      = "govc.env"
    destination = "/home/ubuntu/.govc.env"
  }
  provisioner "file" {
    # Copy vmd configuration file.
    source      = "vmd.env"
    destination = "/home/ubuntu/.vmd.env"
  }
  provisioner "file" {
    # Copy install scripts.
    source      = "setup-jumpbox.sh"
    destination = "/home/ubuntu/setup-jumpbox.sh"
  }
  provisioner "file" {
    # Copy install scripts.
    source      = "setup-cluster.sh"
    destination = "/home/ubuntu/setup-cluster.sh"
  }
  provisioner "remote-exec" {
    # Set up jumpbox.
    inline = [
      "echo ${vsphere_virtual_machine.jumpbox.default_ip_address} jumpbox | sudo tee -a /etc/hosts",
      "chmod +x /home/ubuntu/setup-jumpbox.sh",
      "sh /home/ubuntu/setup-jumpbox.sh"
    ]
  }
}

output "jumpbox_ip_address" {
  value = vsphere_virtual_machine.jumpbox.default_ip_address
}
