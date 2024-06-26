
locals {
  galleries = {
    Linux = {
      description = "Linux Images"
    }
    Windows = {
      description = "Windows Images"
    }
  }
}

resource "azurerm_shared_image_gallery" "default" {
  for_each            = local.galleries
  name                = format("%s_image_gallery_%s", each.key, var.environment)
  resource_group_name = azurerm_resource_group.images.name
  location            = azurerm_resource_group.images.location
  description         = each.value.description
}
