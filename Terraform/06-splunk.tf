# Network Interface
resource "azurerm_network_interface" "indigolabs-vm-splunk-nic" {
  name                = "indigolabs-vm-splunk-nic"
  location            = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name

  ip_configuration {
    name                          = "indigolabs-vm-splunk-nic-config"
    subnet_id                     = azurerm_subnet.indigolabs-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.13.37.50"
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "indigolabs-vm-splunk" {
  name                = "indigolabs-vm-splunk"
  computer_name       = var.splunk-hostname
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name
  location            = data.azurerm_resource_group.cs-soc-playground.location
  size                = var.splunk-size
  disable_password_authentication = false
  admin_username      = var.linux-user
  admin_password      = random_string.linuxpass.result
  network_interface_ids = [
    azurerm_network_interface.indigolabs-vm-splunk-nic.id,
  ]

  os_disk {
    name                 = "indigolabs-vm-splunk-osdisk"
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