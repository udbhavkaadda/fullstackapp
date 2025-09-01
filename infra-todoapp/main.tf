module "resource_group" {
  source                  = "../modules/resource group"
  resource_group_name     = "rg-todoapp"
  resource_group_location = "eastus"
}

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../modules/virtual_network"

  virtual_network_name     = "vnet-todoapp"
  virtual_network_location = "centralindia"
  resource_group_name      = "rg-todoapp"
  address_space            = ["10.0.0.0/16"]
}

module "frontend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/subnet"

  resource_group_name  = "rg-todoapp"
  virtual_network_name = "vnet-todoapp"
  subnet_name          = "frontend-subnet"
  address_prefixes     = ["10.0.1.0/24"]
}


module "public_ip_frontend" {
  depends_on         = [module.resource_group]
  source             = "../modules/public_ip"
  public_ip_name     = "pip-todoapp-frontend"
  resource_group_name = "rg-todoapp"
  location           = "centralindia"
  allocation_method  = "Static"
}

module "frontend_nic" {
  source              = "../modules/nic"
  nic_name            = "nic-frontend"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.frontend_subnet.subnet_id
  public_ip_id        = module.public_ip_frontend.public_ip_id
  environment         = "dev"
}


module "frontend_vm" {
  depends_on = [
    module.frontend_subnet,
    module.public_ip_frontend,
    module.frontend_nic,
    module.key_vault,
    module.vm_username,
    module.vm_password
  ]

  source     = "../modules/virtual_machine"

  resource_group_name  = "rg-todoapp"
  location             = "centralindia"
  vm_name              = "vm-frontend"
  vm_size              = "Standard_B1s"
  ip_name              = module.public_ip_frontend.public_ip_name
  subnet_name          = module.frontend_subnet.subnet_name
  vnet_name            = module.virtual_network.virtual_network_name
  key_vault_name       = module.key_vault.key_vault_name
  username_secret_name = module.vm_username.secret_name
  password_secret_name = module.vm_password.secret_name
  admin_username       = module.vm_username.secret_value
  admin_password       = module.vm_password.secret_value
  image_publisher      = "Canonical"
  image_offer          = "UbuntuServer"
  image_sku            = "24_04-lts"
  image_version        = "latest"
  nic_id               = module.frontend_nic.nic_id
}


module "public_ip_backend" {
  depends_on         = [module.resource_group]
  source             = "../modules/public_ip"
  public_ip_name     = "pip-todoapp-backend"
  resource_group_name = "rg-todoapp"
  location           = "centralindia"
  allocation_method  = "Static"
}

module "backend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/subnet"

  resource_group_name  = "rg-todoapp"
  virtual_network_name = "vnet-todoapp"
  subnet_name          = "backend-subnet"
  address_prefixes     = ["10.0.2.0/24"]
}

module "backend_nic" {
  source              = "../modules/nic"
  nic_name            = "nic-backend"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.backend_subnet.subnet_id
  public_ip_id        = module.public_ip_backend.public_ip_id
  environment         = "dev"
}
module "backend_vm" {
  depends_on = [
    module.backend_subnet,
    module.public_ip_backend,
    module.backend_nic,
    module.key_vault,
    module.vm_username,
    module.vm_password
  ]
  source = "../modules/virtual_machine"

  resource_group_name  = "rg-todoapp"
  location             = "centralindia"
  vm_name              = "vm-backend"
  vm_size              = "Standard_B1s"

  admin_username       = module.vm_username.secret_value
  admin_password       = module.vm_password.secret_value

  image_publisher      = "Canonical"
  image_offer          = "UbuntuServer"
  image_sku            = "20_04-lts"
  image_version        = "latest"

  nic_id               = module.backend_nic.nic_id

  ip_name              = module.public_ip_backend.public_ip_name
  subnet_name          = module.backend_subnet.subnet_name
  vnet_name            = module.virtual_network.virtual_network_name
  key_vault_name       = module.key_vault.key_vault_name
  username_secret_name = module.vm_username.secret_name
  password_secret_name = module.vm_password.secret_name

  tags = {
    environment = "dev"
    owner       = "udbhav"
    project     = "todoapp"
  }
}

module "sql_server" {
  source              = "../modules/sql_server"
  sql_server_name     = "todosqlserverudbhav"
  resource_group_name = "rg-todoapp"
  location            = "centralindia"

  administrator_login          = "sqladmin"
  administrator_login_password = "admin@123456"
}

module "sql_database" {
  depends_on        = [module.sql_server]
  source            = "../modules/sql_database"
  sql_server_id     = module.sql_server.sql_server_id
  sql_database_name = "tododbudbhav"
}

module "key_vault" {
  depends_on         = [module.resource_group]
  source             = "../modules/key_vault"
  key_vault_name     = "udbhavlocker"
  location           = "centralindia"
  resource_group_name = "rg-todoapp"
}

module "vm_password" {
  depends_on         = [module.key_vault, module.resource_group]
  source             = "../modules/key_vault_secret"
  key_vault_name     = "udbhavlocker"
  resource_group_name = "rg-todoapp"
  secret_name        = "vm-password"
  secret_value       = "admin@123456"
}

module "vm_username" {
  depends_on         = [module.key_vault, module.resource_group]
  source             = "../modules/key_vault_secret"
  key_vault_name     = "udbhavlocker"
  resource_group_name = "rg-todoapp"
  secret_name        = "vm-username"
  secret_value       = "devopsadmin"
}

module "bastion" {
  source               = "../modules/bastion"
  bastion_name         = "bastion-todoapp"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.virtual_network.virtual_network_name
  address_prefixes     = ["10.0.3.0/27"]
}

module "load_balancer" {
  source              = "../modules/load_balancer"
  lb_name             = "lb-todoapp"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
}


# Associate Frontend NIC to LB backend pool
resource "azurerm_network_interface_backend_address_pool_association" "frontend_nic_lb" {
  network_interface_id    = module.frontend_nic.nic_id
  ip_configuration_name   = "ipconfig1" # must match NIC ip_configuration block
  backend_address_pool_id = module.load_balancer.bepool_id
}

# Associate Backend NIC to LB backend pool
resource "azurerm_network_interface_backend_address_pool_association" "backend_nic_lb" {
  network_interface_id    = module.backend_nic.nic_id
  ip_configuration_name   = "ipconfig1" # must match NIC ip_configuration block
  backend_address_pool_id = module.load_balancer.bepool_id
}
