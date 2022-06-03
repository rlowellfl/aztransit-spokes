# Create Resource Group for the spoke virtual network
resource "azurerm_resource_group" "spoke" {
  name     = "rg-${var.environment}-${var.location}-${var.workload}"
  location = var.location
  tags     = var.required_tags
}

# Create the spoke virtual network
resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-${var.environment}-${var.location}-spoke-${var.workload}"
  address_space       = var.spokeVnetRange
  location            = var.location
  resource_group_name = var.rgname
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# Create a default NSG within the spoke
resource "azurerm_network_security_group" "nsg" {
  location            = azurerm_resource_group.spoke.location
  name                = "nsg-${var.environment}-${var.location}-${var.workload}"
  resource_group_name = azurerm_resource_group.spoke.name
}

# Create a subnet within the spoke virtual network
resource "azurerm_subnet" "subnet" {
  name                 = var.spokeSubName
  resource_group_name  = azurerm_virtual_network.spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = var.spokeSubRange
}

# Associate the NSG to the newly created subnet
resource "azurerm_subnet_network_security_group_association" "name" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = azurerm_subnet.subnet.id
}

#Peer the spoke Vnet to the Hub Vnet
resource "azurerm_virtual_network_peering" "spoketohub" {
  name                         = "${var.workload}_to_${var.var.hubvnetname}"
  resource_group_name          = azurerm_resource_group.spoke.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hubvnetid
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

#Peer the hub Vnet to the Spoke Vnet
resource "azurerm_virtual_network_peering" "spokefromhub" {
  name                         = "${var.workload}_from_${var.hubvnetname}"
  resource_group_name          = azurerm_resource_group.spoke.name
  virtual_network_name         = var.hubvnetname
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

#Create a route table for the Spoke VNet
resource "azurerm_route_table" "routeTable" {
  name                          = "rt-${var.environment}-${var.location}-spoke-${var.workload}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.spoke.name
  disable_bgp_route_propagation = true
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

#Create a route for all traffic to point to the internal LB in the Hub Vnet
resource "azurerm_route" "toFirewall" {
  name                   = "To_OBEW_LB"
  resource_group_name    = azurerm_resource_group.spoke.name
  route_table_name       = azurerm_route_table.routeTable.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.obewlbid
}

#Associate the new route table to the spoke network
resource "azurerm_subnet_route_table_association" "routeassoc" {
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = azurerm_route_table.routeTable.id
}
