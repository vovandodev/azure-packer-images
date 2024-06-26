terraform {
  required_version = "~> 1.0"
  required_providers {
    azuread = { source = "hashicorp/azuread", version = "~> 2.0" }
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
    random  = { source = "hashicorp/random", version = "~> 3.0" }
  }

  # backend "azurerm" {

  # }
}

provider "azuread" {
  use_oidc  = true
}
provider "azurerm" {
  skip_provider_registration = true
  features {}
  use_oidc  = true
}
