# Terraforming vSphere for Tanzu Kubernetes Grid (TKG)

Use this repository to deploy [TKG](https://tanzu.vmware.com/kubernetes-grid)
to vSphere 6.7u3, leveraging these Terraform scripts.

## Prerequisites

### Prepare vSphere infrastructure

First, make sure DHCP is enabled : this service is required for all TKG nodes.

Create a resource pool under the cluster where TKG is deployed to: use name `TKG`.

![Create a new resource pool](images/vsphere-resource-pool.png)

All TKG VMs will be deployed to this resource pool.

You need to deploy Ubuntu as OVF templates to vSphere to initilize the VM.
- [Ubuntu server cloud image OVA](https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova): used for the jumpbox VM

![Deploy OVF template](images/vsphere-deploy-ovf-part1.png)

![Upload OVF template](images/vsphere-deploy-ovf-part2.png)

![Select OVF template location](images/vsphere-deploy-ovf-part3.png)

![Select resource pool](images/vsphere-deploy-ovf-part4.png)

![Validate OVF template deployment](images/vsphere-deploy-ovf-part5.png)

All OVA files will be uploaded to your vSphere instance as new VMs.
**Make sure you do not start any of these VMs**.

You can now convert each of these VMs to templates:

![Convert VM to template](images/vsphere-deploy-ovf-part6.png)

### Create Terraform configuration

Starting from `terraform.tfvars.tpl`, create new file `terraform.tfvars`:

```yaml
vsphere_password = "changeme"
vsphere_server   = "vcsa.mydomain.com"
network          = "net"
datastore_url    = "ds:///vmfs/volumes/changeme/"

(...)

# Control plane endpoints.
mgt_control_plane_endpoint = 192.168.100.1
wkl_control_plane_endpoint = 192.168.100.2
```

As specified in the [TKG documentation](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-mgmt-clusters-vsphere.html#kubevip-and-nsx-advanced-load-balancer-for-vsphere-2),
you need to use a static IP for the control plane of the management cluster.
Make sure that these IP addresses are not in the DHCP range, but are in the same subnet as the DHCP range.

## Bootstrap the jumpbox

First, initialize Terraform with required plugins:
```bash
$ terraform init
```

Run this command to create a jumpbox VM using Terraform:
```bash
$ terraform apply
```

Using the jumpbox, you'll be able to interact with TKG using the `tanzu` CLI.
You'll also use this jumpbox to connect to nodes using SSH.

Deploying the jumpbox VM takes less than 5 minutes.

At the end of this process, you can retrieve the jumpbox IP address:
```bash
$ terraform output jumpbox_ip_address
10.160.28.120
```

You may connect to the jumpbox VM using account `ubuntu`.

## Deploy TKG management cluster

Connect to the jumpbox VM using SSH:
```bash
$ ssh ubuntu@$(terraform output jumpbox_ip_address)
```

A default configuration for the management cluster has been generated in
the file `~/.config/tanzu/tkg/clusterconfigs/mgmt-cluster-config.yaml`.
You may want to edit this file before creating the management cluster.

NOTE: Default configuration parameters are available in `~/.config/tanzu/tkg/config.yaml`. See [Reference - 1](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-mgmt-clusters-config-vsphere.html) and [Reference - 2](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-tanzu-config-reference.html)

Create the TKG management cluster:
```bash
$ tanzu mc create --file $HOME/.config/tanzu/tkg/clusterconfigs/mgmt-cluster-config.yaml
```
This process takes less than 10 minutes.

## Create TKG workload clusters

You can now create workload clusters.

Create the workload cluster:
```bash
$ tanzu cluster create --file $HOME/.config/tanzu/tkg/clusterconfigs/dev01-cluster-config.yaml
```

This process takes less than 5 minutes.

Import kubeconfig to your context :
```bash
$ tanzu cluster kubeconfig get dev01 --admin
$ kubectl config use-context dev01-admin@dev01
```

Alternatilvely you can export a `kubeconfig` file to access your workload cluster:
```bash
$ tanzu cluster kubeconfig get dev01 --admin --export-file dev01.kubeconfig
```

You can now use this file to access your workload cluster:
```bash
$ KUBECONFIG=dev01.kubeconfig kubectl get nodes
NAME                          STATUS   ROLES    AGE     VERSION
dev01-control-plane-r5nwl     Ready    master   10m     v1.17.3+vmware.2
dev01-md-0-65bc768c89-xjn7h   Ready    <none>   9m44s   v1.17.3+vmware.2
```

Copy this file to your workstation to access the cluster
without using the jumpbox VM.

**Tips** - use this command to merge 2 or more `kubeconfig` files:
```bash
$ KUBECONFIG=dev01.kubeconfig:dev02.kubeconfig kubectl config view --flatten > merged.kubeconfig
```

You may connect to a TKG node using this command (from the jumpbox VM):
```bash
$ ssh capv@node_ip_address
```

Use this command to add more nodes to your workload cluster (from the jumpbox VM):
```bash
$ tanzu cluster scale dev01 --worker-machine-count 3
```

## Connect your workload cluster to a vSphere datastore

The workload cluster you created already includes a vSphere CSI.

The only thing you need to do is to apply a configuration file, designating the
vSphere datastore to use when creating Kubernetes persistent volumes.

Use generated file `vsphere-storageclass.yml`:
```bash
$ kubectl apply -f vsphere-storageclass.yml
```

You're done with TKG deployment. Enjoy!

## Contribute

Contributions are always welcome!

Feel free to open issues & send PR.

## License

Copyright &copy; 2022 [VMware, Inc. or its affiliates](https://vmware.com).

This project is licensed under the [Apache Software License version 2.0](https://www.apache.org/licenses/LICENSE-2.0).
