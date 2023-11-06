# Terraform Azure Public IP Module
resource "azurerm_public_ip" "PIP-VMWEB01-TEST" {
  name                = "PIP-VMWEB01-TEST-UKSOUTH"
  location            = azurerm_resource_group.RG-APP-TEST.location
  resource_group_name = azurerm_resource_group.RG-APP-TEST.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "tf_nginx_web_server"
  }
}

# Terraform Azure Network Interface Module
resource "azurerm_network_interface" "NIC-VMWEB01-TEST" {
  name                = "NIC-VMWEB01-TEST-UKSOUTH"
  location            = azurerm_resource_group.RG-APP-TEST.location
  resource_group_name = azurerm_resource_group.RG-APP-TEST.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SNET-CORE-TEST.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PIP-VMWEB01-TEST.id
  }

  depends_on = [azurerm_public_ip.PIP-VMWEB01-TEST, azurerm_subnet.SNET-CORE-TEST]

  tags = {
    environment = "tf_nginx_web_server"
  }
}

resource "azurerm_linux_virtual_machine" "VM-WEB01-TEST" {
  name                = "VM-WEB01-TEST-UKSOUTH"
  resource_group_name = azurerm_resource_group.RG-APP-TEST.name
  location            = azurerm_resource_group.RG-APP-TEST.location
  size                = "Standard_D2s_v3"
  admin_username      = var.username
  computer_name       = "VM-WEB01-TEST-UKSOUTH"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.NIC-VMWEB01-TEST.id,
  ]

  admin_password = var.password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  depends_on = [azurerm_network_interface.NIC-VMWEB01-TEST, azurerm_resource_group.RG-APP-TEST, azurerm_public_ip.PIP-VMWEB01-TEST]

  tags = {
    environment = "tf_nginx_web_server"
  }
}

resource "azurerm_virtual_machine_extension" "VMEX-CustomScript-VMWEB01-TEST" {
    name                 = "VMEX-CustomScript-VMWEB01-TEST-UKSOUTH"
    virtual_machine_id   = azurerm_linux_virtual_machine.VM-WEB01-TEST.id
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"

    settings = <<SETTINGS
 {
    "fileUris": ["https://fllinuxnginxteststore.blob.core.windows.net/scripts/nginx_config.sh"],
    "commandToExecute": "bash nginx_config.sh"
 }
SETTINGS
}

# resource "null_resource" "run_command" {
#   provisioner "remote-exec" {
#     inline = [
#       "sudo wget -O /etc/nginx/sites-available/default https://fllinuxnginxteststore.blob.core.windows.net/scripts/default"
#     ]
#   }

#     depends_on = [azurerm_virtual_machine_extension.VMEX-CustomScript-VMWEB01-TEST, azurerm_storage_blob.default]                

# }


# resource "azurerm_virtual_machine_extension" "VMEX-NGINXDEFAULT-VMWEB01-TEST" {
#      name                 = "VMEX-NGINXDEFAULT-VMWEB01-TEST-UKSOUTH"
#      virtual_machine_id   = azurerm_linux_virtual_machine.VM-WEB01-TEST.id
#      publisher            = "Microsoft.Azure.Extensions"
#      type                 = "CustomScript"
#      type_handler_version = "2.0"

#      settings = <<SETTINGS
#  {
#      "fileUris": ["https://fllinuxnginxteststore.blob.core.windows.net/scripts/default"],
#      "commandToExecute": "sudo wget -O /etc/nginx/sites-available/default https://fllinuxnginxteststore.blob.core.windows.net/scripts/default"
#  }
# SETTINGS
# }

#To ensure susccessful redirects a dns entry will need to be made with the DNS provider. An A record to the web servers public IP address. 
# & a CNAME record for www to the root domain.

