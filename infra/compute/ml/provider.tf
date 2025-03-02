terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.21.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
  features {}
}

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}