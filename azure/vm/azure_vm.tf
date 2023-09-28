# Create a random id
resource "random_id" "build_suffix" {
  byte_length = 2
}

#creating Resource Group
resource "azurerm_resource_group" "rg" {
  name = var.resource
  location = var.azure_region
}

resource "azurerm_virtual_network" "vnet" {
  name                = "WAAP-VNET"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "waap_re_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "waap-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.waap_re_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.puip.id

  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "waap-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name                       = "arcadia"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ssh"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "vm_inst" {
  name                = "waf-re-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "Demouser"
  admin_password      = "Demouser1234"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  plan {
    name       = "nginx_plus_with_nginx_app_protect_prem_ubuntu2004"
    product    = "nginx_plus_with_nginx_app_protect_premium"
    publisher  = "nginxinc"
  }
  source_image_reference {
    publisher = "nginxinc"
    offer     = "nginx_plus_with_nginx_app_protect_premium"
    sku       = "nginx_plus_with_nginx_app_protect_prem_ubuntu2004"
    version   = "latest"
  }
  user_data = filebase64("./userdata.txt")

  provisioner "file" {
    source      = "default.conf"
    destination = "/home/Demouser/default.conf"

    connection {
      type     = "ssh"
      user     = "Demouser"
      password = "Demouser1234"
      agent    = false
      host     = azurerm_linux_virtual_machine.vm_inst.public_ip_address
    }
  }
}

resource "azurerm_public_ip" "puip" {
  name                = "waf-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "public" {
  name                = "waf-nic-public"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.waap_re_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "securitygroup" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}