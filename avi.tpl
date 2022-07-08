AVI_VM_DIR=${vm_folder}
OVA_AVI_NAME=${avi_ova_name}
OVA_AVI_FILE=${avi_ova_name}.ova
OVA_AVI_SPEC=${avi_ova_name}.json
ALB_CONTROLLER_IP=${avi_ip}
ALB_CONTROLLER_MASK=${avi_controller_network_mask}
ALB_CONTROLLER_GW=${avi_controller_network_gateway}
ALB_CONTROLLER_NAME=avi
ALB_CONTROLLER_NETWORK="esxi-mgmt"
ALB_SSH_KEY="$(cat ~/.ssh/id_rsa.pub)"

