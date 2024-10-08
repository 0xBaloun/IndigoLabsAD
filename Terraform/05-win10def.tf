# Network Interface
resource "azurerm_network_interface" "indigolabs-vm-windows10def-nic" {
  name                 = "indigolabs-vm-windows10def-nic"
  location             = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name  = data.azurerm_resource_group.cs-soc-playground.name

  ip_configuration {
    name                          = "indigolabs-vm-windows10def-config"
    subnet_id                     = azurerm_subnet.indigolabs-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.13.37.150"
  }
}

resource "azurerm_network_interface_nat_rule_association" "indigolabs-vm-windows10def-nic-nat" {
  network_interface_id  = azurerm_network_interface.indigolabs-vm-windows10def-nic.id
  ip_configuration_name = "indigolabs-vm-windows10def-config"
  nat_rule_id           = azurerm_lb_nat_rule.indigolabs-lb-nat-rdp.id
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "indigolabs-vm-windows10def" {
  name                = "indigolabs-vm-windows10def"
  computer_name       = var.win10def-hostname
  size                = var.win10def-size
  provision_vm_agent  = true
  enable_automatic_updates = true
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name
  location            = data.azurerm_resource_group.cs-soc-playground.location
  timezone            = var.timezone
  admin_username      = var.windows-user
  admin_password      = random_string.windowspass.result
  custom_data         = local.custom_data_content
  network_interface_ids = [
    azurerm_network_interface.indigolabs-vm-windows10def-nic.id,
  ]

  os_disk {
    name                 = "indigolabs-vm-windows10def-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-ent-g2"
    version   = "latest"
  }

  additional_unattend_content {
    setting = "AutoLogon"
    content = "<AutoLogon><Password><Value>${random_string.windowspass.result}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.windows-user}</Username></AutoLogon>"
  }

  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = "${file("${path.module}/files/FirstLogonCommands.xml")}"
  }

  tags = {
    DoNotAutoShutDown = "yes"
  }
}