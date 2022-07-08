#! ---------------------------------------------------------------------
#! Basic cluster creation configuration
#! ---------------------------------------------------------------------
CLUSTER_PLAN: dev

INFRASTRUCTURE_PROVIDER: vsphere
ENABLE_CEIP_PARTICIPATION: "false"

CLUSTER_CIDR: 100.96.0.0/11
SERVICE_CIDR: 100.64.0.0/13

#! ---------------------------------------------------------------------
#! Identity management configuration
#! ---------------------------------------------------------------------

IDENTITY_MANAGEMENT_TYPE: "none"

#! Settings for IDENTITY_MANAGEMENT_TYPE: "oidc"
# OIDC_IDENTITY_PROVIDER_CLIENT_ID:
# OIDC_IDENTITY_PROVIDER_CLIENT_SECRET:
# OIDC_IDENTITY_PROVIDER_GROUPS_CLAIM: groups
# OIDC_IDENTITY_PROVIDER_ISSUER_URL:
# OIDC_IDENTITY_PROVIDER_SCOPES: email
# OIDC_IDENTITY_PROVIDER_USERNAME_CLAIM: email

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
#! NSX Advanced Load Balancer configuration
#! ---------------------------------------------------------------------

AVI_ENABLE: false
AVI_CONTROLLER_VERSION: 20.1.7
AVI_CONTROL_PLANE_HA_PROVIDER: false
AVI_CONTROLLER: "${avi_controller}"
AVI_USERNAME: "${avi_username}"
AVI_PASSWORD: "${avi_password}"
AVI_CLOUD_NAME: ${avi_cloud_name}
AVI_SERVICE_ENGINE_GROUP: ${avi_service_engine_group}
AVI_DATA_NETWORK: ${avi_data_network}
AVI_DATA_NETWORK_CIDR: ${avi_data_network_cidr}
AVI_CA_DATA_B64: "${avi_ca_data_b64}"
AVI_LABELS: ""

#! ---------------------------------------------------------------------
#! Node configuration
#! ---------------------------------------------------------------------
VSPHERE_CONTROL_PLANE_NUM_CPUS: "2"
VSPHERE_CONTROL_PLANE_MEM_MIB: "8192"
VSPHERE_CONTROL_PLANE_DISK_GIB: "40"

VSPHERE_WORKER_NUM_CPUS: "2"
VSPHERE_WORKER_MEM_MIB: "8192"
VSPHERE_WORKER_DISK_GIB: "100"

OS_NAME: "ubuntu"
OS_VERSION: "20.04"
OS_ARCH: "amd64"
