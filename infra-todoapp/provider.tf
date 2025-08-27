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
  subscription_id = "18f8e7c5-a3db-4324-b49d-7ef07eace03f"
}
