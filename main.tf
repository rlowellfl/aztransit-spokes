# Configure Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.1.0"
    }
  }
  /*  backend "azurerm" {
    resource_group_name  = "<rg for terraform state backend storage>"
    storage_account_name = "<storage account for terraform state backend storage>"
    container_name       = "transitspokes"
    key                  = "<storage account key>"
  }
*/
}

/*
# Pull data from the transit hub deployment tfstate file
data "terraform_remote_state" "transit" {
  backend = "azurerm"
  config = {
    resource_group_name  = "<rg for panorama terraform state backend storage>"
    storage_account_name = "<storage account for terraform state backend storage>"
    container_name       = "transittfstate"
    key                  = "<storage account key>"
  }
}
*/

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Deploy one or more spoke virtual networks
module "spoke-network" {
  for_each       = var.spoke_network
  source         = "./modules/spoke-network"
  location       = var.location
  hubvnetname    = data.transit.hubvnetname
  hubvnetid      = data.transit.hubvnetid
  obewlbid       = data.transit.obewlbid
  environment    = var.environment
  workload       = each.value["workloadname"]
  spokeVnetRange = each.value["spokeVnetRange"]
  spokeSubName   = each.value["spokeSubName"]
  spokeSubRange  = each.value["spokeSubRange"]
}