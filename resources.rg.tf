resource "azurerm_resource_group" "images" {
  name     = format("%s-packer-images", var.environment)
  location = var.location
}

resource "azurerm_resource_group" "packervms" {
  name     = format("%s-packer-temp", var.environment)
  location = var.location
}