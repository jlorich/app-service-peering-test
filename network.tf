# App Service Vnet
resource "azurerm_virtual_network" "app_service" {
  name                = "app-service-vnet"
  resource_group_name = "${azurerm_resource_group.default.name}"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.default.location}"
}

resource "azurerm_subnet" "app_service_default" {
  name                 = "default"
  resource_group_name  = "${azurerm_resource_group.default.name}"
  virtual_network_name = "${azurerm_virtual_network.app_service.name}"
  address_prefix       = "10.0.0.0/24"
}

resource "azurerm_subnet" "app_service_apps" {
  name                 = "apps"
  resource_group_name  = "${azurerm_resource_group.default.name}"
  virtual_network_name = "${azurerm_virtual_network.app_service.name}"
  address_prefix       = "10.0.1.0/24"

  delegation {
    name = "serverfarms_delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# VM Vnet
resource "azurerm_virtual_network" "virtual_machine" {
  name                = "vm-vnet"
  resource_group_name = "${azurerm_resource_group.default.name}"
  address_space       = ["10.1.0.0/16"]
  location            = "${azurerm_resource_group.default.location}"
}

resource "azurerm_subnet" "vm_default" {
  name                 = "default"
  resource_group_name  = "${azurerm_resource_group.default.name}"
  virtual_network_name = "${azurerm_virtual_network.virtual_machine.name}"
  address_prefix       = "10.1.0.0/24"
}

# Peerings
resource "azurerm_virtual_network_peering" "app_service_to_vm" {
  name                         = "peer-to-vm"
  resource_group_name          = "${azurerm_resource_group.default.name}"
  virtual_network_name         = "${azurerm_virtual_network.app_service.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.virtual_machine.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "vm_to_app_service" {
  name                         = "peer-to-app-service"
  resource_group_name          = "${azurerm_resource_group.default.name}"
  virtual_network_name         = "${azurerm_virtual_network.virtual_machine.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.app_service.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
