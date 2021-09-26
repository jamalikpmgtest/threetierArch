provider "azurerm" {
  features {}
}

module "resourcegroup" {
  source   = "./modules/resourcegroup"
  name     = var.name
  location = var.location
}

module "networking" {
  source         = "./modules/networking"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  vnetcidr       = var.vnetcidr
  websubnetcidr  = var.websubnetcidr
  appsubnetcidr  = var.appsubnetcidr
  dbsubnetcidr   = var.dbsubnetcidr
}

module "securitygroup" {
  source         = "./modules/securitygroup"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  web_subnet_id  = module.networking.websubnet_id
  app_subnet_id  = module.networking.appsubnet_id
  db_subnet_id   = module.networking.dbsubnet_id

  depends_on = [
    module.networking.websubnet_id,
    module.networking.appsubnet_id,
    module.networking.dbsubnet_id
  ]
}

module "webcompute" {
  source              = "./modules/compute"
  location            = module.resourcegroup.location_id
  resource_group      = module.resourcegroup.resource_group_name
  web_subnet_id       = module.networking.websubnet_id
  web_host_name       = var.web_host_name
  web_username        = var.web_username
  web_os_password     = var.web_os_password
  availabilitySetName = "web-availableSet"
  nicName             = "web-nic"
  ipconfigName        = "web-config"
  vmName              = "web-vms"
  osdiskName          = "web-osdisk"

}
module "appcompute" {
  source              = "./modules/compute"
  location            = module.resourcegroup.location_id
  resource_group      = module.resourcegroup.resource_group_name
  web_subnet_id       = module.networking.appsubnet_id
  web_host_name       = var.app_host_name
  web_username        = var.app_username
  web_os_password     = var.app_os_password
  availabilitySetName = "app-availableSet"
  nicName             = "app-nic"
  ipconfigName        = "app-config"
  vmName              = "app-vms"
  osdiskName          = "app-osdisk"

}



module "database" {
  source                    = "./modules/database"
  location                  = module.resourcegroup.location_id
  resource_group            = module.resourcegroup.resource_group_name
  primary_database          = var.primary_database
  primary_database_version  = var.primary_database_version
  primary_database_admin    = var.primary_database_admin
  primary_database_password = var.primary_database_password
}
