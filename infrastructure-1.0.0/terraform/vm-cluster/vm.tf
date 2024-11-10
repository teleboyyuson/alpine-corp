
resource "azurerm_network_interface" "private_nic" {
  name                = "privateNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "privateIPConfig"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "webserver" {
  count               = 3
  name                = "webserver-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [
    azurerm_network_interface.public_nic.id,
    azurerm_network_interface.private_nic.id
  ]
  size                = "Standard_B1s"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_username = "adminuser"
  admin_password = "Password1234!"
}

resource "azurerm_mysql_flexible_server" "mysql" {
  count               = 2
  name                = "mysqlserver-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  administrator_login = "mysqladmin"
  administrator_password = "Password1234!"
  sku_name            = "Standard_B1ms"
  storage_mb          = 5120
  version             = "8.0"

  storage_profile {
    storage_mb = 5120
  }

  backup {
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  network {
    delegated_subnet_id = azurerm_subnet.private.id
  }
}

resource "azurerm_mysql_flexible_database" "db" {
  count               = 2
  name                = "mydatabase-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql[count.index].name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
