resource "azurerm_resource_group" "RG-NETWORK-TEST" {
  name     = "RG-NETWORK-TEST-UKSOUTH"
  location = "Uk South"

  tags = {
    environment = "tf_nginx_web_server"
  }
}

resource "azurerm_resource_group" "RG-APP-TEST" {
  name     = "RG-APP-TEST-UKSOUTH"
  location = "Uk South"

  tags = {
    environment = "tf_nginx_web_server"
  }
}

resource "azurerm_resource_group" "RG-STORAGE-TEST" {
  name     = "RG-STORAGE-TEST-UKSOUTH"
  location = "Uk South"

  tags = {
    environment = "tf_nginx_web_server"
  }
}
