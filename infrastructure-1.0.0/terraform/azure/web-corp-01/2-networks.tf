# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${terraform.workspace}-${var.rg_name}"
  location            = "${var.location}"
  resource_group_name = "rg-${terraform.workspace}-${var.rg_name}"
  address_space       = "${var.vnet}"

  depends_on = [azurerm_resource_group.rg]
}

# Subnet for VMs
resource "azurerm_subnet" "snet" {
  name                 = "snet-${terraform.workspace}-${var.rg_name}"
  resource_group_name  = "rg-${terraform.workspace}-${var.rg_name}"
  virtual_network_name = "vnet-${terraform.workspace}-${var.rg_name}"
  address_prefixes     = "${var.snet}"

  depends_on = [azurerm_virtual_network.vnet]
}