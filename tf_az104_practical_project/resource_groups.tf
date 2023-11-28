resource "azurerm_resource_group" "RG-NETWORK-TEST-UKSOUTH" {
  name     = "RG-NETWORK-TEST-UKSOUTH"
  location = var.uks

  tags = var.tags
}

resource "azurerm_resource_group" "RG-ON-PREM-TEST-UKSOUTH" {
  name     = "RG-ON-PREM-TEST-UKSOUTH"
  location = var.uks

  tags = var.tags
}

resource "azurerm_resource_group" "RG-STORAGE-TEST-UKSOUTH" {
  name     = "RG-STORAGE-TEST-UKSOUTH"
  location = var.uks

  tags = var.tags
}

resource "azurerm_resource_group" "RG-CLIENTS-TEST-UKSOUTH" {
  name     = "RG-CLIENTS-TEST-UKSOUTH"
  location = var.uks

  tags = var.tags
}

resource "azurerm_resource_group" "RG-BAS-TEST-UKSOUTH" {
  name     = "RG-BAS-TEST-UKSOUTH"
  location = var.uks

  tags = var.tags
}