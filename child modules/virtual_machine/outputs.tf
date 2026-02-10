output "public_ip_id" {
  value = data.azurerm_public_ip.frontend_ip.id
}

output "public_ip_address" {
  value = data.azurerm_public_ip.frontend_ip.ip_address
}

output "subnet_id" {
  value = data.azurerm_subnet.selected.id
}

output "key_vault_id" {
  value = data.azurerm_key_vault.kv.id
}

output "admin_username" {
  value     = data.azurerm_key_vault_secret.vm-username.value
  sensitive = true
}

output "admin_password" {
  value     = data.azurerm_key_vault_secret.vm-password.value
  sensitive = true
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

