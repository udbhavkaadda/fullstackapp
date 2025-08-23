variable "ip_name" {
  description = "Name of the Public IP to fetch"
  type        = string
}

variable "subnet_name" {
  description = "Name of the Subnet to fetch"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network where subnet exists"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
}

variable "username_secret_name" {
  description = "Name of the Key Vault secret containing the VM admin username"
  type        = string
}

variable "password_secret_name" {
  description = "Name of the Key Vault secret containing the VM admin password"
  type        = string
}

variable "location" {}
variable "vm_name" {}
variable "vm_size" {}
variable "admin_username" {}
variable "admin_password" {
  sensitive = true
}
variable "image_publisher" {}
variable "image_offer" {}
variable "image_sku" {}
variable "image_version" {}
variable "nic_id" {}

variable "tags" {
  type    = map(string)
  default = {}
}
