packer {

  required_version = ">= 1.9.4"

  required_plugins {
    windows-update = {
      version = " >= 0.14.3"
      source  = "github.com/rgl/windows-update"
    }
  }

}

source "azure-arm" "windows-2022" {
  subscription_id                   = ""
  tenant_id                         = ""
  # client_id                         = "{{env `AZURE_POLICY_TF_PIPELINE_SPN`}}"
  # client_secret                     = "{{env `AZURE_POLICY_TF_PIPELINE_SPN_PASS`}}"
  managed_image_name                = format("windows-%s", formatdate("YYYYMMDDhhmm", timestamp()))
  build_resource_group_name         = ""
  managed_image_resource_group_name = ""
  os_type                           = "Windows"
  image_publisher                   = "MicrosoftWindowsServer"
  image_offer                       = "WindowsServer"
  image_sku                         = "2022-Datacenter"
  vm_size                           = "Standard_D3_v2"
  use_azure_cli_auth                = true
  communicator                      = "winrm"
  winrm_insecure                    = true
  winrm_timeout                     = "10m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"


  
  shared_image_gallery_destination {
    subscription = ""
    resource_group = ""
    gallery_name = "Windows_image_gallery_*"
    image_name = "WindowsServer_2022"
    image_version = "0.0.{{timestamp}}"
    /* replication_regions = ["North Central US"] */
  }

  azure_tags = {}
}

build {
  sources = ["sources.azure-arm.windows-2022"]

  provisioner "powershell" {
    inline = ["WINRM QuickConfig -q"]
  }

  provisioner "windows-restart" {}

  provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = ["exclude:$_.Title -like '*Preview*'",
      "exclude:$_.Title -like '*Defender*'",
      "exclude:$_.InstallationBehavior.CanRequestUserInput",
    "include:$true"]
    restart_timeout = "120m"
  }

  provisioner "powershell" {
    inline = ["& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
          "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select-Object -ExpandProperty ImageState; if ($imageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState; Start-Sleep -Seconds 10 } else { break } }"]
  }

}