# Setup govc CLI.
export GOVC_URL=${vsphere_server}
export GOVC_USERNAME=${vsphere_user}
export GOVC_PASSWORD=${vsphere_password}
export GOVC_DATACENTER=${datacenter}
export GOVC_NETWORK=${network}
export GOVC_DATASTORE=${datastore}
export GOVC_RESOURCE_POOL=/${datacenter}/host/Cluster/Resources/${resource_pool}
export GOVC_FOLDER=/${datacenter}/vm/${vm_folder}
export GOVC_INSECURE=true
