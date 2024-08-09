locals {
  location_sanitize = lower(replace(var.azure_location, " ", ""))
}

resource "azurerm_subnet" "target_subnets" {
  provider            = azurerm.target-account
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name
  #for_each = var.subnet_network_rules
  #location            = var.azure_location
  address_prefixes = var.subnet_network_rules

  name = "${var.subnet_identifier}-subnet-${local.location_sanitize}"

  #tags = merge(var.default_tags,
  #  var.application_tags,
  #  map("Name", "vn-${var.subnet_identifier != "" ? "${var.subnet_identifier}-" : ""}${var.resource_group_name}-${local.location_sanitize}"),
  #  map("module-source", "/home/ukatru/cloud/azure/terraform-modules/modules/network/subnet")
  #)
}


#=================================================
# Network security group
#=================================================
resource "azurerm_network_security_group" "network_security_group" {
    provider            = azurerm.target-account
  count = var.create_network_security_group ? 1 : 0
  depends_on = [ azurerm_subnet.target_subnets ]

  name = "network-sg-${var.subnet_identifier != "" ? "${var.subnet_identifier}-" : ""}${var.resource_group_name}-${local.location_sanitize}"

  location            = var.azure_location
  resource_group_name = var.resource_group_name


  tags = merge(
   var.application_tags,
   map("Name", "network-sg-${var.subnet_identifier != "" ? "${var.subnet_identifier}-" : ""}${var.resource_group_name}-${local.location_sanitize}"),
    map("module-source", "/home/ukatru/cloud/azure/terraform-modules/modules/network/subnet")
  )
}


resource "azurerm_network_security_rule" "network_security_rule" {
   provider            = azurerm.target-account

  count = var.create_network_security_group ? length(var.network_security_group_rules) : 0
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.network_security_group[0].name
  depends_on = [ azurerm_subnet.target_subnets, azurerm_network_security_group.network_security_group]

  name                        = lookup(var.network_security_group_rules[count.index], "name")
  priority                    = lookup(var.network_security_group_rules[count.index], "priority")
  direction                   = lookup(var.network_security_group_rules[count.index], "direction")
  access                      = lookup(var.network_security_group_rules[count.index], "access")
  protocol                    = lookup(var.network_security_group_rules[count.index], "protocol")
  source_port_range           = lookup(var.network_security_group_rules[count.index], "source_port_range")
  destination_port_range      = lookup(var.network_security_group_rules[count.index], "destination_port_range")
  source_address_prefix       = lookup(var.network_security_group_rules[count.index], "source_address_prefix")
  destination_address_prefix  = lookup(var.network_security_group_rules[count.index], "destination_address_prefix")

}

resource "azurerm_subnet_network_security_group_association" "subnet_network_security_group_association" {
  provider            = azurerm.target-account  
  #for_each = azurerm_subnet.target_subnets
   #for_each =  azurerm_subnet.target_subnets ? var.network_security_group_rules : 0
  depends_on = [ azurerm_subnet.target_subnets, azurerm_network_security_group.network_security_group,azurerm_network_security_rule.network_security_rule]
  subnet_id                 = azurerm_subnet.target_subnets.id
  network_security_group_id = azurerm_network_security_group.network_security_group[0].id
}
