vsphere_user     = "administrator@vsphere.local"
vsphere_server   = "changeme"
vsphere_password = "changeme"
network          = "user-workload"
datastore_url    = "ds:///vmfs/volumes/vsan:changeme/"
datacenter       = "vc01"
cluster          = "vc01cl01"
datastore        = "vsanDatastore"

resource_pool = "TKG"
vm_folder     = "tkg"

ubuntu_template = "focal-server-cloudimg-amd64"

customerconnect_user = "changeme"
customerconnect_pass = "changeme"

# Management control plane endpoint - Outside of DHCP range
mgt_control_plane_endpoint = "changeme"
wkl_control_plane_endpoint = "changeme"

# Uncomment to enable HTTP proxy support.
# http_proxy_host = "my.http.proxy"
# http_proxy_port = 8080
