locals {
  location_sanitize = lower(replace(var.azure_location, " ", ""))
}
resource "azurerm_virtual_network" "main" {
  count               = var.create_vpc == true ? 1 : 0
  resource_group_name = var.resource_group_name
  address_space       = var.vn_address_space
  location            = var.azure_location

  name = "vn-${var.vn_identifier != "" ? "${var.vn_identifier}-" : ""}${var.resource_group_name}-${local.location_sanitize}"

  tags = merge(var.default_tags,
    var.application_tags,
    map("Name", "vn-${var.vn_identifier != "" ? "${var.vn_identifier}-" : ""}${var.resource_group_name}-${local.location_sanitize}"),
    map("module-source", "/home/ukatru/cloud/azure/terraform-modules/modules/network/azure_vn")
  )
}
