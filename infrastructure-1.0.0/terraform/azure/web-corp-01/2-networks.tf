# Virtual Network
resource "azurerm_virtual_network" "vn" {
  name                = "vn-${terraform.workspace}-${var.rg_name}"
  location            = "${var.location}"
  resource_group_name = "rg-${terraform.workspace}-${var.rg_name}"
  address_space       = "${var.cidr_blocks}"
}

# Subnet for VMs
resource "azurerm_subnet" "sb" {
  name                 = "sb-${terraform.workspace}-${var.rg_name}"
  resource_group_name  = "rg-${terraform.workspace}-${var.rg_name}"
  virtual_network_name = "vn-${terraform.workspace}-${var.rg_name}"
  address_prefixes     = "${var.subnet}"
}