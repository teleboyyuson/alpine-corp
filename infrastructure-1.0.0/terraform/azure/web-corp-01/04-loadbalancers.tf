# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_pip" {
  name                = "lb_pip-${terraform.workspace}-${var.rg_name}"
  resource_group_name = "rg-${terraform.workspace}-${var.rg_name}"
  location            = "${var.location}"
  allocation_method   = "Static"
  sku                  = "Basic"

  depends_on = [azurerm_resource_group.rg]
}

# Load Balancer
resource "azurerm_lb" "lb_web" {
  name                = "lb_web-${terraform.workspace}-${var.rg_name}"
  resource_group_name = "rg-${terraform.workspace}-${var.rg_name}"
  location            = "${var.location}"
  sku                 = "Basic"
}

# Load Balancer Frontend IP
resource "azurerm_lb_frontend_ip_configuration" "lb_fip" {
  name                  = "lb_fip-${terraform.workspace}-${var.rg_name}"
  resource_group_name   = "rg-${terraform.workspace}-${var.rg_name}"
  loadbalancer_id       = azurerm_lb.lb_web.id
  public_ip_address_id  = azurerm_public_ip.lb_pip.id
}

# Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "lb_bp" {
  name                  = "lb_lb-${terraform.workspace}-${var.rg_name}"
  resource_group_name   = "rg-${terraform.workspace}-${var.rg_name}"
  loadbalancer_id       = azurerm_lb.lb_web.id
}

# Load Balancer Health Probe
resource "azurerm_lb_probe" "lb_probe" {
  name                = "http-healthprobe"
  resource_group_name = "rg-${terraform.workspace}-${var.rg_name}"
  loadbalancer_id     = azurerm_lb.lb_web.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
}

# Load Balancer Rule (HTTP)
resource "azurerm_lb_rule" "lb_rule" {
  name                        = "http-rule"
  resource_group_name         = "rg-${terraform.workspace}-${var.rg_name}"
  loadbalancer_id             = azurerm_lb.lb_web.id
  protocol                    = "Tcp"
  frontend_port               = 80
  backend_port                = 80
  frontend_ip_configuration_id = azurerm_lb_frontend_ip_configuration.example.id
  backend_address_pool_id     = azurerm_lb_backend_address_pool.lb_bp.id
  probe_id                    = azurerm_lb_probe.lb_probe.id
}