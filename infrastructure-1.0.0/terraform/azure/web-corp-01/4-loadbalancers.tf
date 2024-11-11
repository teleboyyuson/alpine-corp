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

  depends_on = [azurerm_resource_group.rg]
}

# Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "lb_bp" {
  name                  = "lb_lb-${terraform.workspace}-${var.rg_name}"
  loadbalancer_id       = azurerm_lb.lb_web.id

  depends_on = [azurerm_lb.lb_web]
}

# Load Balancer Health Probe
resource "azurerm_lb_probe" "lb_probe" {
  name                = "http-healthprobe"
  loadbalancer_id     = azurerm_lb.lb_web.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"

  depends_on = [azurerm_lb.lb_web]
}

# Load Balancer Rule (HTTP)
resource "azurerm_lb_rule" "lb_rule_http" {
  loadbalancer_id                = azurerm_lb.lb_web.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "lb_fip-${terraform.workspace}-${var.rg_name}"
}

resource "azurerm_lb_rule" "lb_rule_https" {
  loadbalancer_id                = azurerm_lb.lb_web.id
  name                           = "https-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "lb_fip-${terraform.workspace}-${var.rg_name}"
}
