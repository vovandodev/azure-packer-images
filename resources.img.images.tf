locals {
  shared_images = {
    "Ubuntu-18.04" = {
      type      = "Linux"
      publisher = "MCP"
      offer     = "Ubuntu"
      sku       = "18.04-LTS"
    },
    "Ubuntu-22.04" = {
      type      = "Linux"
      publisher = "MCP"
      offer     = "Ubuntu"
      sku       = "22.04-LTS"
    },
    "WindowsServer_2022" = {
      type      = "Windows"
      publisher = "MCP"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition-hotpatch"
    },
    "WindowsServer_2022" = {
      type      = "Windows"
      publisher = "MCP"
      offer     = "WindowsServer"
      sku       = "2022-Datacenter"
    },  
  
  }
}

resource "azurerm_shared_image" "default" {
  for_each            = local.shared_images
  name                = each.key
  gallery_name        = azurerm_shared_image_gallery.default[each.value.type].name
  resource_group_name = azurerm_shared_image_gallery.default[each.value.type].resource_group_name
  location            = azurerm_shared_image_gallery.default[each.value.type].location
  os_type             = each.value.type

  identifier {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
  }
}
