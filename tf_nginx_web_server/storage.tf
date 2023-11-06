
# Terraform App Pool Storage Account
resource "azurerm_storage_account" "fllinuxnginxteststore" {
  name                     = "fllinuxnginxteststore"
  resource_group_name      = azurerm_resource_group.RG-STORAGE-TEST.name
  location                 = azurerm_resource_group.RG-STORAGE-TEST.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = "tf_nginx_web_server"
  }
  depends_on = [azurerm_resource_group.RG-STORAGE-TEST]
}

#Terraform Storage Container for Scripts
resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_name  = azurerm_storage_account.fllinuxnginxteststore.name
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.fllinuxnginxteststore]
}

#Terraform Storage Blob Upload of NGINX Config 
resource "azurerm_storage_blob" "nginx_config" {
  name                   = "nginx_config.sh"
  storage_account_name   = azurerm_storage_account.fllinuxnginxteststore.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "nginx_config.sh"
  depends_on             = [azurerm_storage_account.fllinuxnginxteststore, azurerm_storage_container.scripts]
}

#Terraform Storage Blob Upload of NGINX Default File 
resource "azurerm_storage_blob" "default" {
  name                   = "default"
  storage_account_name   = azurerm_storage_account.fllinuxnginxteststore.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "default"
  depends_on             = [azurerm_storage_account.fllinuxnginxteststore, azurerm_storage_container.scripts]
}

