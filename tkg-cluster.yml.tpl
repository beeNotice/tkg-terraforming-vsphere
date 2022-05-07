#! ---------------------------------------------------------------------
#! Basic cluster creation configuration
#! ---------------------------------------------------------------------
CLUSTER_PLAN: dev

INFRASTRUCTURE_PROVIDER: vsphere
IDENTITY_MANAGEMENT_TYPE: none
ENABLE_CEIP_PARTICIPATION: "false"

CLUSTER_CIDR: 100.96.0.0/11
SERVICE_CIDR: 100.64.0.0/13


#! ---------------------------------------------------------------------
#! vSphere configuration
#! ---------------------------------------------------------------------
VSPHERE_SERVER: "${vcenter_server}"
VSPHERE_USERNAME: "${vcenter_user}"
VSPHERE_PASSWORD: "${vcenter_password}"
VSPHERE_DATACENTER: "${datacenter}"
VSPHERE_DATASTORE: "${datastore}"
VSPHERE_NETWORK: "${network}"
VSPHERE_RESOURCE_POOL: "${resource_pool}"
VSPHERE_FOLDER: "${vm_folder}"
VSPHERE_INSECURE: "true"

DEPLOY_TKG_ON_VSPHERE7: true
ENABLE_TKGS_ON_VSPHERE7: false

#! ---------------------------------------------------------------------
#! Node configuration
#! ---------------------------------------------------------------------
VSPHERE_CONTROL_PLANE_NUM_CPUS: "2"
VSPHERE_CONTROL_PLANE_MEM_MIB: "8192"
VSPHERE_CONTROL_PLANE_DISK_GIB: "40"

VSPHERE_WORKER_NUM_CPUS: "2"
VSPHERE_WORKER_MEM_MIB: "8192"
VSPHERE_WORKER_DISK_GIB: "100"

OS_NAME: "photon"
OS_VERSION: "3"
OS_ARCH: "amd64"
