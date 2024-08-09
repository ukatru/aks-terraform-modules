provider "azurerm" {
  alias = "target-account"
}

variable "azure_location" {}

variable "create_vpc" {
  default = true
}

variable "vn_address_space" {}

variable "resource_group_name" {
  type = string
}
variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "application_tags" {
  type    = map(string)
  default = {}
}

variable "vn_identifier" {
  type    = string
  default = "vn-test"
}
