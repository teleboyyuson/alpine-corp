# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${terraform.workspace}-${var.rg_name}"
  location = "East US"

  tags = {
    terraform = "true"
  }
}