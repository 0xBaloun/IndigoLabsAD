# Network Interface
resource "azurerm_network_interface" "indigolabs-vm-syslog-nic" {
  name                = "indigolabs-vm-syslog-nic"
  location            = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name

  ip_configuration {
    name                          = "indigolabs-vm-syslog-nic-config"
    subnet_id                     = azurerm_subnet.indigolabs-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.13.37.40"
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "indigolabs-vm-syslog" {
  name                = "indigolabs-vm-syslog"
  computer_name       = var.syslog-hostname
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name
  location            = data.azurerm_resource_group.cs-soc-playground.location
  size                = var.syslog-size
  disable_password_authentication = false
  admin_username      = var.syslog-user
  admin_password      = random_string.linuxpass.result
  network_interface_ids = [
    azurerm_network_interface.indigolabs-vm-syslog-nic.id,
  ]

  os_disk {
    name                 = "indigolabs-vm-syslog-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }

  tags = {
    DoNotAutoShutDown = "yes"
  }
}