##################################################################################
# Note - this must be deployed from the same subscription as the hub network deployment
##################################################################################

# Pull data from the transit hub deployment tfstate file
data "terraform_remote_state" "transit" {
  backend = "azurerm"
  config = {
    resource_group_name  = "<resource group for terraform state file storage>"
    storage_account_name = "<storage account for terraform state file storage>"
    container_name       = "terraform-aztransit-nva"
    key                  = "<storage account key>"
  }
}

# Configure the Microsoft Azure Provider for the hub network subscription
provider "azurerm" {
  features {}
  subscription_id     = "<hub network subscription ID>"
  storage_use_azuread = true
}

# Configure the Microsoft Azure Provider for the spoke network subscription
provider "azurerm" {
  features {}
  alias               = "spoke"
  subscription_id     = "<spoke network subscription ID>"
  storage_use_azuread = true
}

# Deploy one or more spoke virtual networks using the spoke provider
module "spoke-network" {
  for_each       = var.spoke_network
  source         = "./modules/spoke-network"
  providers      = { azurerm = azurerm.spoke }
  location       = var.location
  hubvnetname    = data.terraform_remote_state.transit.outputs.hubvnetname
  hubvnetid      = data.terraform_remote_state.transit.outputs.hubvnetid
  obewlbip       = data.terraform_remote_state.transit.outputs.obewlbip
  environment    = var.environment
  required_tags  = var.required_tags
  workloadname   = each.value["workloadname"]
  spokeVnetRange = each.value["spokeVnetRange"]
  spokeSubName   = each.value["spokeSubName"]
  spokeSubRange  = each.value["spokeSubRange"]
}

# Create the hub-side peerings to newly created spoke networks using the hub provider
module "hub-peering" {
  depends_on   = [module.spoke-network]
  for_each     = var.spoke_network
  source       = "./modules/hub-peering"
  remotevnetid = module.spoke-network[each.key].spokeNetworkID
  spokename    = module.spoke-network[each.key].spokeNetworkName
  rgname       = data.terraform_remote_state.transit.outputs.hubrgname
  hubvnetname  = data.terraform_remote_state.transit.outputs.hubvnetname
}
