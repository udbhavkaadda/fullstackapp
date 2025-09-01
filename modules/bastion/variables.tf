variable "bastion_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "virtual_network_name" {}
variable "address_prefixes" {
  default = ["10.0.3.0/27"]
}
