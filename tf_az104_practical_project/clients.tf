
#Bastion Host Setup
resource "azurerm_public_ip" "PIP-BAS-CLIENTS-TEST-UKSOUTH" {
  name                = "PIP-BAS-CLIENTS-TEST-UKSOUTH"
  resource_group_name = azurerm_resource_group.RG-BAS-TEST-UKSOUTH.name
  location            = var.uks
  allocation_method   = "Static"
  sku                = "Standard"

  tags = var.tags
}

resource "azurerm_bastion_host" "BAS-CLIENTS-TEST-UKSOUTH" {
  name                = "BAS-CLIENTS-TEST-UKSOUTH"
  location            = var.uks
  resource_group_name = azurerm_resource_group.RG-BAS-TEST-UKSOUTH.name

  ip_configuration {
    name                 = "bas_ip_configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnetClients.id
    public_ip_address_id = azurerm_public_ip.PIP-BAS-CLIENTS-TEST-UKSOUTH.id
  }

  depends_on = [azurerm_subnet.AzureBastionSubnetClients, azurerm_public_ip.PIP-BAS-CLIENTS-TEST-UKSOUTH]

  tags = var.tags
}



#-------------------------------------------------------------------------------------------------------------#
#Windows Clients Setup
resource "azurerm_network_interface" "VM-CLIENT01-NIC-TEST-UKSOUTH" {
  name                = "VM-CLIENT01-NIC-TEST-UKSOUTH"
  location            = var.uks
  resource_group_name = azurerm_resource_group.RG-CLIENTS-TEST-UKSOUTH.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SNET-CLIENTS-TEST-UKSOUTH.id
    private_ip_address_allocation = "Dynamic" #Change this to static at somepoint
  }
}

resource "azurerm_windows_virtual_machine" "VM-CLIENT01-VM-TEST-UKSOUTH" {
  name                = "VM-CLIENT01-VM-TEST-UKSOUTH"
  computer_name       = "CLIENT01"
  resource_group_name = azurerm_resource_group.RG-CLIENTS-TEST-UKSOUTH.name
  location            = var.uks
  size                = "Standard_B1s"
  admin_username      = var.vm_host_username
  admin_password      = var.vm_host_password
  network_interface_ids = [
    azurerm_network_interface.VM-CLIENT01-NIC-TEST-UKSOUTH.id,
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

resource "azurerm_network_interface" "VM-CLIENT02-NIC-TEST-UKSOUTH" {
  name                = "VM-CLIENT02-NIC-TEST-UKSOUTH"
  location            = var.uks
  resource_group_name = azurerm_resource_group.RG-CLIENTS-TEST-UKSOUTH.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SNET-CLIENTS-TEST-UKSOUTH.id
    private_ip_address_allocation = "Dynamic" #Change this to static at somepoint
  }
}

resource "azurerm_windows_virtual_machine" "VM-CLIENT02-VM-TEST-UKSOUTH" {
  name                = "VM-CLIENT02-VM-TEST-UKSOUTH"
  computer_name       = "CLIENT02"
  resource_group_name = azurerm_resource_group.RG-CLIENTS-TEST-UKSOUTH.name
  location            = var.uks
  size                = "Standard_B1s"
  admin_username      = var.vm_host_username
  admin_password      = var.vm_host_password
  network_interface_ids = [
    azurerm_network_interface.VM-CLIENT02-NIC-TEST-UKSOUTH.id,
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