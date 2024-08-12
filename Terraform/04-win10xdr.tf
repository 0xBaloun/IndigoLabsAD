# Network Interface
resource "azurerm_network_interface" "indigolabs-vm-windows10xdr-nic" {
  name                 = "indigolabs-vm-windows10xdr-nic"
  location             = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name  = data.azurerm_resource_group.cs-soc-playground.name

  ip_configuration {
    name                          = "indigolabs-vm-windows10xdr-config"
    subnet_id                     = azurerm_subnet.indigolabs-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.13.37.160"
  }
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "indigolabs-vm-windows10xdr" {
  name                = "indigolabs-vm-windows10xdr"
  computer_name       = var.win10xdr-hostname
  size                = var.win10xdr-size
  provision_vm_agent  = true
  enable_automatic_updates = true
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name
  location            = data.azurerm_resource_group.cs-soc-playground.location
  timezone            = var.timezone
  admin_username      = var.windows-user
  admin_password      = random_string.windowspass.result
  custom_data         = local.custom_data_content
  network_interface_ids = [
    azurerm_network_interface.indigolabs-vm-windows10xdr-nic.id,
  ]

  os_disk {
    name                 = "indigolabs-vm-windows10xdr-osdisk"
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