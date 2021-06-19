terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.26"
    }
  }

  # using terraform cloud as a remote backend
  backend "remote" {
    organization = "memandip-org-dev"
    workspaces {
      name = "terraform-starter"
    }
  }

  required_version = ">= 0.14.9"
}

# configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "West Europe"

  tags = {
    Environment = "Terraform Getting Started"
    Team        = "DevOps"
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}
