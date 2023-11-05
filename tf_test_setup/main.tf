terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }

    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

provider "azurerm" {
  features {}
}