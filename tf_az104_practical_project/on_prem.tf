resource "azurerm_public_ip" "VM-ON-PREM-PIP-TEST-UKSOUTH" {
  name                = "VM-ON-PREM-PIP-TEST-UKSOUTH"
  resource_group_name = azurerm_resource_group.RG-ON-PREM-TEST-UKSOUTH.name
  location            = var.uks
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "VM-ON-PREM-NIC-TEST-UKSOUTH" {
  name                = "VM-ON-PREM-NIC-TEST-UKSOUTH"
  location            = var.uks
  resource_group_name = azurerm_resource_group.RG-ON-PREM-TEST-UKSOUTH.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SNET-ON-PREM-TEST-UKSOUTH.id
    private_ip_address_allocation = "Dynamic" #Change this to static at somepoint
    public_ip_address_id          = azurerm_public_ip.VM-ON-PREM-PIP-TEST-UKSOUTH.id
  }
}

resource "azurerm_windows_virtual_machine" "VM-ON-PREM-VM-TEST-UKSOUTH" {
  name                = "VM-ON-PREM-VM-TEST-UKSOUTH"
  computer_name       = "VmOnPrem"
  resource_group_name = azurerm_resource_group.RG-ON-PREM-TEST-UKSOUTH.name
  location            = var.uks
  size                = "Standard_D2s_v3"
  admin_username      = var.vm_host_username
  admin_password      = var.vm_host_password
  network_interface_ids = [
    azurerm_network_interface.VM-ON-PREM-NIC-TEST-UKSOUTH.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }
}