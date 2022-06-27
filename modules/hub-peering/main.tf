#Peer the hub Vnet to the Spoke Vnet
resource "azurerm_virtual_network_peering" "spokefromhub" {
  name                         = "hub_to_${var.spokename}"
  resource_group_name          = var.rgname
  virtual_network_name         = var.hubvnetname
  remote_virtual_network_id    = var.remotevnetid
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}
