resource "azurerm_linux_virtual_machine" "vm" {
  count                    = 1
  name                     = "vm-${count.index + 1}-${terraform.workspace}-${var.rg_name}"
  resource_group_name      = "rg-${terraform.workspace}-${var.rg_name}"
  location                 = "${var.location}"
  size                     = "Standard_B1ls"  # Adjust size as needed
  admin_username           = "adminuser"
  admin_password           = "abcd@1234"
//  admin_ssh_key {
//    public_key = file("~/.ssh/id_rsa.pub")  # Path to your SSH public key
//  }
  network_interface_ids    = [azurerm_network_interface.vm_nic[count.index].id]
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
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }
}
