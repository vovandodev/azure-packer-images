source "azure-arm" "ubuntu-1804" {
  subscription_id                   = ""
  tenant_id                         = ""
  #client_id                         = ""
  managed_image_name                = format("ubuntu-%s", formatdate("YYYYMMDDhhmm", timestamp()))
  build_resource_group_name         = ""
  managed_image_resource_group_name = ""
  os_type                           = "Linux"
  image_publisher                   = "Canonical"
  image_offer                       = "UbuntuServer"
  image_sku                         = "18.04-LTS"
  vm_size                           = "Standard_D3_v2"
  use_azure_cli_auth                = true
  
  shared_image_gallery_destination {
    subscription = ""
    resource_group = ""
    gallery_name = "Linux_image_gallery_*"
    image_name = "Ubuntu-18.04"
    image_version = "1.0.0"
    replication_regions = ["North Central US"]
  }

  azure_tags = {}
}

build {
  sources = ["sources.azure-arm.ubuntu-1804"]

  provisioner "shell" {
    script = "../scripts/linux/bastion.sh"
  }
}