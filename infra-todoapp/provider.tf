terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "e8ad8a11-5e89-4545-9309-27ed1a0cd62f"
}

