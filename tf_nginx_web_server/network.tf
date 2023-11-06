# Terraform Azure Virtual Network Module
resource "azurerm_virtual_network" "VNET-CORE-TEST" {
  name                = "VNET-CORE-TEST-UKSOUTH"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG-NETWORK-TEST.location
  resource_group_name = azurerm_resource_group.RG-NETWORK-TEST.name

  depends_on = [azurerm_resource_group.RG-NETWORK-TEST]

  tags = {
    environment = "tf_nginx_web_server"
  }
}

# Terraform Azure Subnet Module
resource "azurerm_subnet" "SNET-CORE-TEST" {
  name                 = "SNET-CORE-TEST-UKSOUTH"
  resource_group_name  = azurerm_resource_group.RG-NETWORK-TEST.name
  virtual_network_name = azurerm_virtual_network.VNET-CORE-TEST.name
  address_prefixes     = ["10.0.0.0/24"]

  depends_on = [azurerm_virtual_network.VNET-CORE-TEST]

}

# Terraform Azure Network Security Group Module
resource "azurerm_network_security_group" "NSG-CORE-TEST" {
  name                = "NSG-CORE-TEST-UKSOUTH"
  location            = azurerm_resource_group.RG-NETWORK-TEST.location
  resource_group_name = azurerm_resource_group.RG-NETWORK-TEST.name
  depends_on          = [azurerm_resource_group.RG-NETWORK-TEST]

  tags = {
    environment = "tf_nginx_web_server"
  }
}

# Terraform Azure Network Security Group Rule Module
resource "azurerm_network_security_rule" "NSGSR-SSH-TEST" {
  name                        = "NSGSR-SSH-TEST-UKSOUTH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.publicip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG-NETWORK-TEST.name
  network_security_group_name = azurerm_network_security_group.NSG-CORE-TEST.name

  depends_on = [azurerm_resource_group.RG-NETWORK-TEST, azurerm_network_security_group.NSG-CORE-TEST]


}

resource "azurerm_network_security_rule" "NSGSR-HTTP-TEST" {
  name                        = "NSGSR-HTTP-TEST-UKSOUTH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG-NETWORK-TEST.name
  network_security_group_name = azurerm_network_security_group.NSG-CORE-TEST.name

  depends_on = [azurerm_resource_group.RG-NETWORK-TEST, azurerm_network_security_group.NSG-CORE-TEST]


}

# Terraform Azure Network Security Group Association Module
resource "azurerm_subnet_network_security_group_association" "NSGASSOC-CORE-TEST" {
  subnet_id                 = azurerm_subnet.SNET-CORE-TEST.id
  network_security_group_id = azurerm_network_security_group.NSG-CORE-TEST.id

  depends_on = [azurerm_subnet.SNET-CORE-TEST, azurerm_network_security_group.NSG-CORE-TEST]
}

