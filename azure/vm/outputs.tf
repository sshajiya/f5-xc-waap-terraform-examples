output "azure_region" {
  value       = var.azure_region
  description = "Azure Region"
}

output "resource_name" {
  value       = var.resource
  description = "Default resources name"
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Azure Resource Group Name"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Azure Virtual Network Name"
}

output "subnet_name" {
  value       = azurerm_subnet.waap_re_subnet.name
  description = "Azure Subnet Name"
}

output "subnet_id" {
  value       = azurerm_subnet.waap_re_subnet.id
  description = "Azure Subnet ID"
}

output "vm_name" {
   value       = azurerm_linux_virtual_machine.vm_inst.name
   description = "Azure VM name"
}

output "public_ip" {
   value       = azurerm_public_ip.puip.ip_address
   description = "Azure VM public IP"
}