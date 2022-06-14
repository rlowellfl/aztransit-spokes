# Environmental variables
variable "location" {
  description = "Location for the deployment"
  type        = string
}

variable "environment" {
  description = "Environment for the deployment"
  type        = string
}

# Tag variables
variable "required_tags" {
  description = "List of required tags to be applied to the resource group. Tags will be inherited by child resources automatically based on Azure policy."
  type        = map(any)
}

# Hub network variables
variable "hubvnetname" {
  type = string
}
variable "hubvnetid" {
  type = string
}
variable "obewlbip" {
  type = string
}

# Spoke network variables
variable "spoke_network" {
  description = "Defines spoke networks that branch from the main transit hub."
  type = map(object({
    workloadname   = string
    spokeVnetRange = list(string)
    spokeSubName   = string
    spokeSubRange  = list(string)
  }))
}
