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
  subscription_id = "02fc6674-9e4d-4764-8702-0c4550e06df7"
}

  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # subscription_id = var.subscription_id
  # tenant_id       = var.tenant_id