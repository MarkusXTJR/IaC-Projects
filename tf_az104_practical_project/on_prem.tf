resource "azurerm_public_ip" "HV-ON-PREM-PIP-TEST-UKSOUTH" {
  name                = "HV-ON-PREM-PIP-TEST-UKSOUTH"
  resource_group_name = azurerm_resource_group.RG-ON-PREM-TEST-UKSOUTH.name
  location            = var.uks
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "HV-ON-PREM-NIC-TEST-UKSOUTH" {
  name                = "HV-ON-PREM-NIC-TEST-UKSOUTH"
  location            = var.uks
  resource_group_name = azurerm_resource_group.RG-ON-PREM-TEST-UKSOUTH.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SNET-ON-PREM-TEST-UKSOUTH.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.HV-ON-PREM-PIP-TEST-UKSOUTH.id
  }
}

resource "azurerm_windows_virtual_machine" "HV-ON-PREM-VM-TEST-UKSOUTH" {
  name                = "HV-ON-PREM-VM-TEST-UKSOUTH"
  computer_name       = "Hypervisor01"
  resource_group_name = azurerm_resource_group.RG-ON-PREM-TEST-UKSOUTH.name
  location            = var.uks
  size                = "Standard_D2s_v3"
  admin_username      = var.hv_host_username
  admin_password      = var.hv_host_password
  network_interface_ids = [
    azurerm_network_interface.HV-ON-PREM-NIC-TEST-UKSOUTH.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}