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

# AVI
avi_ova_name="controller-20.1.7-9154"
avi_ip ="changeme"
avi_controller ="changeme"
avi_controller_network_mask="changeme"
avi_controller_network_gateway="changeme"
avi_username = "admin"
avi_password = "changeme"
avi_cloud_name = "Default-Cloud"
avi_service_engine_group = "Default-Group"
avi_data_network = "user-workload"
avi_data_network_cidr = "changeme"
avi_ca_data_b64 = "changeme"
