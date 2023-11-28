# Terraform Azure Virtual Network Module
resource "azurerm_virtual_network" "VNET-ON-PREM-TEST-UKSOUTH" {
  name                = "VNET-ON-PREM-TEST-UKSOUTH"
  address_space       = ["172.16.0.0/12"]
  location            = var.uks
  resource_group_name = azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH.name

  depends_on = [azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH]
  tags       = var.tags
}

# Terraform Azure Subnet Module
resource "azurerm_subnet" "SNET-ON-PREM-TEST-UKSOUTH" {
  name                 = "SNET-ON-PREM-TEST-UKSOUTH"
  resource_group_name  = azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH.name
  virtual_network_name = azurerm_virtual_network.VNET-ON-PREM-TEST-UKSOUTH.name
  address_prefixes     = ["172.16.0.0/16"]

  depends_on = [azurerm_virtual_network.VNET-ON-PREM-TEST-UKSOUTH]

}

# Terraform Azure Network Security Group Module
resource "azurerm_network_security_group" "NSG-ON-PREM-TEST-UKSOUTH" {
  name                = "NSG-ON-PREM-TEST-UKSOUTH"
  location            = var.uks
  resource_group_name = azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH.name
  depends_on          = [azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH]

  tags = var.tags
}

# Terraform Azure Network Security Group Rule Module
resource "azurerm_network_security_rule" "NSGSR-RDP-TEST-UKSOUTH" {
  name                        = "NSGSR-RDP-TEST-UKSOUTH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.mypublicip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH.name
  network_security_group_name = azurerm_network_security_group.NSG-ON-PREM-TEST-UKSOUTH.name

  depends_on = [azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH, azurerm_network_security_group.NSG-ON-PREM-TEST-UKSOUTH]


}

# Terraform Azure Network Security Group Association Module
resource "azurerm_subnet_network_security_group_association" "NSGASSOC-ON-PREM-TEST-UKSOUTH" {
  subnet_id                 = azurerm_subnet.SNET-ON-PREM-TEST-UKSOUTH.id
  network_security_group_id = azurerm_network_security_group.NSG-ON-PREM-TEST-UKSOUTH.id

  depends_on = [azurerm_subnet.SNET-ON-PREM-TEST-UKSOUTH, azurerm_network_security_group.NSG-ON-PREM-TEST-UKSOUTH]
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------#

# Terraform Azure Virtual Network Module
resource "azurerm_virtual_network" "VNET-CLIENTS-TEST-UKSOUTH" {
  name                = "VNET-CLIENTS-TEST-UKSOUTH"
  address_space       = ["192.168.0.0/24"]
  location            = var.uks
  resource_group_name = azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH.name

  depends_on = [azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH]
  tags       = var.tags
}

# Terraform Azure Subnet Module
resource "azurerm_subnet" "SNET-CLIENTS-TEST-UKSOUTH" {
  name                 = "SNET-CLIENTS-TEST-UKSOUTH"
  resource_group_name  = azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH.name
  virtual_network_name = azurerm_virtual_network.VNET-CLIENTS-TEST-UKSOUTH.name
  address_prefixes     = ["192.168.0.0/26"]

  depends_on = [azurerm_virtual_network.VNET-CLIENTS-TEST-UKSOUTH]

}

# Terraform Azure Network Security Group Module
resource "azurerm_network_security_group" "NSG-CLIENTS-TEST-UKSOUTH" {
  name                = "NSG-CLIENTS-TEST-UKSOUTH"
  location            = var.uks
  resource_group_name = azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH.name
  depends_on          = [azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH]

  tags = var.tags
}

#Terraform Azure Network Security Group Rule Module
resource "azurerm_network_security_rule" "NSGSR-CLIENTS-BAS-TEST-UKSOUTH" {
  name                        = "NSGSR-CLIENTS-BAS-TEST-UKSOUTH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [3389, 22]
  source_address_prefix       = "192.168.0.64/26"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH.name
  network_security_group_name = azurerm_network_security_group.NSG-CLIENTS-TEST-UKSOUTH.name

  depends_on = [azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH, azurerm_network_security_group.NSG-CLIENTS-TEST-UKSOUTH]
}

# Terraform Azure Network Security Group Association Module
resource "azurerm_subnet_network_security_group_association" "NSGASSOC-CLIENTS-TEST-UKSOUTH" {
  subnet_id                 = azurerm_subnet.SNET-CLIENTS-TEST-UKSOUTH.id
  network_security_group_id = azurerm_network_security_group.NSG-CLIENTS-TEST-UKSOUTH.id

  depends_on = [azurerm_subnet.SNET-CLIENTS-TEST-UKSOUTH, azurerm_network_security_group.NSG-CLIENTS-TEST-UKSOUTH]
}

#Bastion Subnet
resource "azurerm_subnet" "AzureBastionSubnetClients" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.RG-NETWORK-TEST-UKSOUTH.name
  virtual_network_name = azurerm_virtual_network.VNET-CLIENTS-TEST-UKSOUTH.name
  address_prefixes     = ["192.168.0.64/26"]
}