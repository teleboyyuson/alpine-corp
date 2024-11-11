resource "azurerm_linux_virtual_machine" "vm" {
  count                    = 1
  name                     = "vm-${terraform.workspace}-${var.rg_name}"
  resource_group_name      = "rg-${terraform.workspace}-${var.rg_name}"
  location                 = "${var.location}"
  size                     = "Standard_B1ls"  # Adjust size as needed
  admin_username           = "adminuser"
  admin_password           = "abcd@1234"
  disable_password_authentication = false
//  admin_ssh_key {
//    public_key = file("~/.ssh/id_rsa.pub")  # Path to your SSH public key
//  }
  network_interface_    = [azurerm_network_interface.vm_nic[count.index].id]
  tags = {
    environment = "dev"
  }

  custom_data = filebase64("scripts/bootstrap.sh")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  count                    = 1
  name                     = "vm_nic-${count.index + 1}"
  location                 = "${var.location}"
  resource_group_name      = "rg-${terraform.workspace}-${var.rg_name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-priv.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  count                    = 1
  name                     = "vm_nic-${count.index + 1}"
  location                 = "${var.location}"
  resource_group_name      = "rg-${terraform.workspace}-${var.rg_name}"

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.snet-pub.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_bp_assoc" {
  network_interface_id    = azurerm_network_interface.vm_nic-1.id
  ip_configuration_name   = "lb_bp_connection"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_bp.id
}