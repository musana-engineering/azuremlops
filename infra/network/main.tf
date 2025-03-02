locals {
  firewall_whitelist = ["8.29.228.126"]
  location           = "eastus2"

  tags = {
    provisioner = "terraform"
    location    = "eastus2"
    project     = "aiops"
  }
}

module "network" {
  source              = "../modules/vnet"
  tags                = local.tags
  location            = local.location
  firewall_whitelist  = local.firewall_whitelist
  resource_group_name = "rg-network"

  private_dns_zones = [
    "privatelink.blob.core.windows.net",
    "privatelink.eastus2.azmk8s.io",
    "privatelink.vaultcore.azure.net",
  "musana.engineering"]

  virtual_networks = {

    "core" = {
      name          = "vnet-aiops"
      address_space = ["10.141.0.0/16"]
      dns_servers   = ["168.63.129.16"]
    }
  }

  nat_gateways = {

    "core" = {
      name              = "ngw-aiops"
      allocation_method = "Static"
      sku_name          = "Standard"
    }
  }

  subnets = {

    "aks" = {
      name                                          = "snet-core"
      virtual_network_name                          = "vnet-aiops"
      address_prefixes                              = ["10.141.0.0/17"]
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    }

    "controlplane" = {
      name                                          = "snet-aks-cplane"
      virtual_network_name                          = "vnet-aiops"
      address_prefixes                              = ["10.141.129.0/28"]
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    }
  }
}
