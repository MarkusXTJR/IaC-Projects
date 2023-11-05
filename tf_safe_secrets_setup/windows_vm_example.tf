resource "azurerm_resource_group" "windows_vm_example" {
  name     = "windows_vm_example"
  location = "Uk South"
}

resource "azurerm_virtual_network" "windows_vm_vn" {
  name                = "windows_vm_vn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.windows_vm_example.location
  resource_group_name = azurerm_resource_group.windows_vm_example.name
}

resource "azurerm_subnet" "windows_vm_sn" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.windows_vm_example.name
  virtual_network_name = azurerm_virtual_network.windows_vm_vn.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "windows_vm_nsg" {
  name                = "windows_vm_nsg"
  resource_group_name = azurerm_resource_group.windows_vm_example.name
  location            = azurerm_resource_group.windows_vm_example.location
}

resource "azurerm_network_security_rule" "windows_vm_nsg_rule_rdp" {
  name                        = "windows_vm_nsg_rule_rdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.publicip
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.windows_vm_example.name
  network_security_group_name = azurerm_network_security_group.windows_vm_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "windows_vm_nsg_association" {
  subnet_id                 = azurerm_subnet.windows_vm_sn.id
  network_security_group_id = azurerm_network_security_group.windows_vm_nsg.id
}

resource "azurerm_public_ip" "windows_vm_pip" {
  name                = "windows_vm_pip"
  resource_group_name = azurerm_resource_group.windows_vm_example.name
  location            = azurerm_resource_group.windows_vm_example.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "windows_vm_nic" {
  name                = "windows_vm_nic"
  location            = azurerm_resource_group.windows_vm_example.location
  resource_group_name = azurerm_resource_group.windows_vm_example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.windows_vm_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows_vm_pip.id
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm_machine" {
  name                = "windows_vm_machine"
  computer_name       = "windowsvm"
  resource_group_name = azurerm_resource_group.windows_vm_example.name
  location            = azurerm_resource_group.windows_vm_example.location
  size                = "Standard_D2s_v3"
  admin_username      = var.username
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.windows_vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}