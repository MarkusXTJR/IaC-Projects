resource "azurerm_resource_group" "RG-TEST" {
  name     = "RG-TEST"
  location = "Uk South"

  tags = {
    environment = "tf_test_setup"   
  }
}