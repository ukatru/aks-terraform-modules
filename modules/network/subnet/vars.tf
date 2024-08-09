provider "azurerm" {
  alias = "target-account"
}

variable "azure_location" {}

variable "resource_group_name" {
  type = string
}

variable "application_tags" {
  type    = map(string)
  default = {}
}

variable "subnet_identifier" {
  type    = string
  default = "poc"
}

variable "subnet_network_rules" {
  type = list(any)
}

variable "create_network_security_group" {
  default = false
}

variable "network_security_group_rules" {
  type = list(any)
  default = []
}

variable "vnet_name" {
  type = string
}