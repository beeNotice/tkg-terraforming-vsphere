# Outputs for Terraform

output "controllers" {
  value = vsphere_virtual_machine.controller.*.default_ip_address
}
