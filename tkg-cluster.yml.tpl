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
