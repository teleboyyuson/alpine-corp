# Resource Group
resource "azurerm_resource_group" "webcorp-01" {
  name     = "rg-${var.rg_name}"
  location = "East US"
}