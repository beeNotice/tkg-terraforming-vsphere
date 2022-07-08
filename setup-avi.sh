#!/bin/sh

# Prepare environment
. /home/ubuntu/.env

# Export vars
set -a
. /home/ubuntu/.govc.env
. /home/ubuntu/.vmd.env
. /home/ubuntu/.avi.env
set +a

# Upload AVI OVA - AVI files are available on Vault - AVI 20.1.7 - controller-20.1.7-9154
# https://vault.vmware.com/group/nsx/avi-networks-technical-resources
# https://portal.avipulse.vmware.com/software/vantage
AVI_URL=""
curl -L $AVI_URL -o $OVA_AVI_NAME

replace_json() {
	# ${1} : Source File
	# ${2} : Nested Item 
	# ${3} : Key to find 
	# ${4} : Value of Key 
	# ${5} : Key to update 
	# ${6} : Update Key 
	
	cat ${1} | \
	jq '(.'"${2}"'[] | select (.'"${3}"' == "'"${4}"'") | .'"${5}"') = "'"${6}"'"' > ${1}-tmp
	cp ${1}-tmp ${1} ; rm ${1}-tmp
}

# Create Ressource Pool
govc pool.create $GOVC_RESOURCE_POOL

# Create VM Folder
govc folder.create /${GOVC_DATACENTER}/vm/${AVI_VM_DIR}

# Initialize spec
govc import.spec ${OVA_AVI_FILE} > $OVA_AVI_SPEC

# Configure data
cat ${OVA_AVI_SPEC} | jq '.IPAllocationPolicy="fixedPolicy"' > ${OVA_AVI_SPEC}-tmp
cp ${OVA_AVI_SPEC}-tmp ${OVA_AVI_SPEC} ; rm ${OVA_AVI_SPEC}-tmp

replace_json ${OVA_AVI_SPEC} "PropertyMapping" "Key" "avi.mgmt-ip.CONTROLLER" "Value" "${ALB_CONTROLLER_IP}"
replace_json ${OVA_AVI_SPEC} "PropertyMapping" "Key" "avi.mgmt-mask.CONTROLLER" "Value" "${ALB_CONTROLLER_MASK}"
replace_json ${OVA_AVI_SPEC} "PropertyMapping" "Key" "avi.default-gw.CONTROLLER" "Value" "${ALB_CONTROLLER_GW}"
replace_json ${OVA_AVI_SPEC} "PropertyMapping" "Key" "avi.sysadmin-public-key.CONTROLLER" "Value" "${ALB_SSH_KEY}"
replace_json ${OVA_AVI_SPEC} "PropertyMapping" "Key" "avi.hostname.CONTROLLER" "Value" "${ALB_CONTROLLER_NAME}"
replace_json ${OVA_AVI_SPEC} "NetworkMapping" "Name" "Management" "Network" "${ALB_CONTROLLER_NETWORK}"

# Import OVF
govc import.ova -options=$OVA_AVI_SPEC -name="${OVA_AVI_NAME}" ${OVA_AVI_FILE}
govc object.mv /${GOVC_FOLDER}/${OVA_AVI_NAME} /${GOVC_DATACENTER}/vm/${AVI_VM_DIR}
govc vm.power -on ${OVA_AVI_NAME}

# Remove data
rm ${OVA_AVI_SPEC}

# Add DNS entry
# Follow Doc 