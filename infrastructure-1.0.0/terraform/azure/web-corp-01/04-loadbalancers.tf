# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_pip" {
  name                = "lb_pip-${terraform.workspace}-${var.rg_name}"
  resource_group_name = "rg-${terraform.workspace}-${var.rg_name}"
  location            = "${var.location}"
  allocation_method   = "Static"
  sku                  = "Standard"

  depends_on = [azurerm_resource_group.rg]
}

# Load Balancer
resource "azurerm_lb" "lb_web" {
  name                = "lb_web-${terraform.workspace}-${var.rg_name}"
  resource_group_name = "rg-${terraform.workspace}-${var.rg_name}"
  location            = "${var.location}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "lb_fip-${terraform.workspace}-${var.rg_name}"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}
