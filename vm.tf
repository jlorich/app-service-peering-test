resource "azurerm_network_interface" "vm1" {
  name                = "${var.name}-nic"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"

  ip_configuration {
    name                          = "vmipconfiguration"
    subnet_id                     = "${azurerm_subnet.vm_default.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm1.id}"
  }
}

resource "azurerm_public_ip" "vm1" {
  name                    = "vm1-pip"
  location                = "${azurerm_resource_group.default.location}"
  resource_group_name     = "${azurerm_resource_group.default.name}"
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

resource "azurerm_virtual_machine" "vm1" {
  name                  = "${var.prefix}-vm1"
  location              = "${azurerm_resource_group.default.location}"
  resource_group_name   = "${azurerm_resource_group.default.name}"
  network_interface_ids = ["${azurerm_network_interface.vm1.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
  storage_os_disk {
    name              = "vm1disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "testvm"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false

    ssh_keys {
      key_data = "${var.ssh_key}"
      path     = "/home/${var.username}/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_virtual_machine_extension" "simple_server" {
  name                 = "simple-server"
  location             = "${azurerm_resource_group.default.location}"
  resource_group_name  = "${azurerm_resource_group.default.name}"
  virtual_machine_name = "${azurerm_virtual_machine.vm1.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo python -m SimpleHTTPServer 80 &"
    }
SETTINGS
}



#### VM2 ####

resource "azurerm_network_interface" "vm2" {
  name                = "${var.name}-nic2"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"

  ip_configuration {
    name                          = "vmipconfiguration"
    subnet_id                     = "${azurerm_subnet.app_service_default.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm2.id}"
  }
}

resource "azurerm_public_ip" "vm2" {
  name                    = "vm2-pip"
  location                = "${azurerm_resource_group.default.location}"
  resource_group_name     = "${azurerm_resource_group.default.name}"
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

resource "azurerm_virtual_machine" "vm2" {
  name                  = "${var.prefix}-vm2"
  location              = "${azurerm_resource_group.default.location}"
  resource_group_name   = "${azurerm_resource_group.default.name}"
  network_interface_ids = ["${azurerm_network_interface.vm2.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
  storage_os_disk {
    name              = "vm2disk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm2"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false

    ssh_keys {
      key_data = "${var.ssh_key}"
      path     = "/home/${var.username}/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_virtual_machine_extension" "simple_server2" {
  name                 = "simple-server"
  location             = "${azurerm_resource_group.default.location}"
  resource_group_name  = "${azurerm_resource_group.default.name}"
  virtual_machine_name = "${azurerm_virtual_machine.vm2.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo python -m SimpleHTTPServer 80 &"
    }
SETTINGS
}
