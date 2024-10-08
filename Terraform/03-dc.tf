# Network Interface
resource "azurerm_network_interface" "indigolabs-vm-dc-nic" {
  name                 = "indigolabs-vm-dc-nic"
  location             = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name  = data.azurerm_resource_group.cs-soc-playground.name

  ip_configuration {
    name                          = "indigolabs-vm-dc-config"
    subnet_id                     = azurerm_subnet.indigolabs-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.13.37.10"
  }
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "indigolabs-vm-dc" {
  name                     = "indigolabs-vm-dc"
  computer_name            = var.dc-hostname
  size                     = var.dc-size
  provision_vm_agent       = true
  enable_automatic_updates = true
  resource_group_name      = data.azurerm_resource_group.cs-soc-playground.name
  location                 = data.azurerm_resource_group.cs-soc-playground.location
  timezone                 = var.timezone
  admin_username           = var.windows-user
  admin_password           = random_string.windowspass.result
  custom_data              = local.custom_data_content
  network_interface_ids    = [
    azurerm_network_interface.indigolabs-vm-dc-nic.id,
  ]

  os_disk {
    name                 = "indigolabs-vm-dc-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
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