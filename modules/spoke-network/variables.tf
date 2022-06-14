variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "workloadname" {
  type = string
}

variable "spokeVnetRange" {
  type = list(string)
}

variable "spokeSubName" {
  type = string
}

variable "spokeSubRange" {
  type = list(string)
}

variable "hubvnetname" {
  type = string
}
variable "hubvnetid" {
  type = string
}
variable "obewlbip" {
  type = string
}

variable "required_tags" {
  type = map(string)
}
