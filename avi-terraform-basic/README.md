

## automate AVI controller 
Spin up n avi Controller in v-center

## Prerequisites:
- Make sure terraform in installed in the orchestrator VM
- Make sure VMware credential/details are configured as environment variable:
```
TF_VAR_vsphere_user=******
TF_VAR_vsphere_server=******
TF_VAR_vsphere_password=******
```
- Make sure you have VM template file in V-center which follow this name controller-<avi-version>-template
```
controller-20.1.1-9071-template
```

## Environment:

Terraform plan has been tested against:

### terraform

```
Your version of Terraform is out of date! The latest version
is 0.13.4. You can update by downloading from https://www.terraform.io/downloads.html
Terraform v0.13.0
+ provider registry.terraform.io/hashicorp/vsphere v1.24.2
```

### Avi version
```
Avi 20.1.1 with one controller node or three controller nodes
```

### V-center version:
- VMware (V-center 6.7.0, ESXi, 6.7.0, 15160138)

## Input/Parameters:
- All the paramaters/variables are stored in variables.tf
- If you want to use DHCP, comment the following in controller.tf:
```
#  vapp {
#    properties = {
#      "mgmt-ip"     = element(var.controller.mgmt_ips, count.index)
#      "mgmt-mask"   = element(var.controller.mgmt_masks, count.index)
#      "default-gw"  = element(var.controller.default_gws, count.index)
#    }
#  }
```
- If you want to use static IPs, uncomment the following in controller.tf:
```
  vapp {
    properties = {
      "mgmt-ip"     = element(var.controller.mgmt_ips, count.index)
      "mgmt-mask"   = element(var.controller.mgmt_masks, count.index)
      "default-gw"  = element(var.controller.default_gws, count.index)
    }
  }
```
Also, the lists associated with the three variables above need to have a length equal to the variable controller.count.
i.e, if controller.count == 3, then you need to have:
  - controller.networks with 3 elements like ["netA", "netB", "netC"]
  - controller.mgmt_ips with 3 elements like ["ipA", "ipB", "ipC"]
  - controller.mgmt_masks with 3 elements like ["maskA", "maskB", "maskC"]
  - controller.default_gws with 3 elements like ["gwA", "gwB", "gwC"]

## Use the the terraform script to:
- Create a new folder within v-center
- Spin up n Avi Controller (DHCP or static IP)

## Run the terraform:
- to apply the plan
```
cd ~ ; git clone https://github.com/tacobayle/vmwAviControllerFromTemplate ; cd vmwAviControllerFromTemplate ; terraform init ; terraform apply -auto-approve
```
- to destroy the plan
```
terraform destroy -auto-approve
```
