variable "location" {
  default = "Canadacentral"
}

variable "humber_id" {
  default = "n01692684"
}

variable "admin_username" {
  default = "n01692684"
}

variable "admin_password" {
  type      = string
  default   = "n01692684@Humber"
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "Complex{@ssw0rd123!"
}

module "common_n01692684" {
  source              = "./modules/common_n01692684"
  humber_id           = var.humber_id
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  log_retention_days  = 30
}

locals {
  storage_account_blob_endpoint = module.common_n01692684.storage_account_blob_endpoint
}

module "datadisk_n01692684" {
  source              = "./modules/datadisk_n01692684"
  humber_id           = var.humber_id
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  vm_ids = {
    0 = module.vmlinux_n01692684.vm1_id,
    1 = module.vmlinux_n01692684.vm2_id,
    2 = module.vmlinux_n01692684.vm3_id,
  }
}

module "loadbalancer_n01692684" {
  source              = "./modules/loadbalancer_n01692684"
  humber_id           = var.humber_id
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  vm_nics = {
    vm1 = module.vmlinux_n01692684.vm1_nic_id,
    vm2 = module.vmlinux_n01692684.vm2_nic_id,
    vm3 = module.vmlinux_n01692684.vm3_nic_id
  }
}

module "database_n01692684" {
  source                        = "./modules/database_n01692684"
  humber_id                     = var.humber_id
  location                      = var.location
  resource_group_name           = module.resource_group.resource_group_name
  admin_username                = var.admin_username
  admin_password                = var.db_password
  storage_mb                    = 5120
  backup_retention_days         = 7
  auto_grow_enabled             = true
  public_network_access_enabled = true
}

module "network_n01692684" {
  source              = "./modules/network_n01692684"
  address_space       = ["10.0.0.0/16"]
  address_prefixes    = ["10.0.0.0/24"]
  humber_id           = var.humber_id
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
}

module "resource_group" {
  source              = "./modules/resource_group_n01692684"
  admin_username      = var.admin_username
  private_key         = file("~/.ssh/id_rsa")
  humber_id           = var.humber_id
  location            = var.location
  resource_group_name = "RG"
}

module "vmlinux_n01692684" {
  source                        = "./modules/vmlinux_n01692684"
  humber_id                     = var.humber_id
  location                      = var.location
  resource_group_name           = module.resource_group.resource_group_name
  admin_username                = var.admin_username
  public_key                    = file("~/.ssh/id_rsa.pub")
  subnet_id                     = module.network_n01692684.subnet_id
  private_key                   = file("~/.ssh/id_rsa")
  vm_count                      = 3
  storage_account_blob_endpoint = local.storage_account_blob_endpoint
}

module "vmwindows_n01692684" {
  source                        = "./modules/vmwindows_n01692684"
  humber_id                     = var.humber_id
  location                      = var.location
  resource_group_name           = module.resource_group.resource_group_name
  admin_username                = var.admin_username
  admin_password                = var.admin_password
  vm_count                      = 1
  subnet_id                     = module.network_n01692684.subnet_id
  storage_account_blob_endpoint = module.common_n01692684.storage_account_blob_endpoint
}

