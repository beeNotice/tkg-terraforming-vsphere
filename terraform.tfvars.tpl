vsphere_user = "administrator@vsphere.local"
vsphere_password = "changeme"
vsphere_server   = "vcsa.mydomain.com"
network          = "net"
datastore_url    = "ds:///vmfs/volumes/changeme/"
datacenter = "vc01"
cluster = "vc01cl01"
datastore = "vsanDatastore"

resource_pool = "tkg"
vm_folder = "tkg"

network = "user-workload"
ubuntu_template = "focal-server-cloudimg-amd64"

customerconnect_user="changeme"
customerconnect_pass="changeme"

# Management control plane endpoint - Outside of DHCP range
control_plane_endpoint = "192.168.100.1"

# Uncomment to enable HTTP proxy support.
# http_proxy_host = "my.http.proxy"
# http_proxy_port = 8080
