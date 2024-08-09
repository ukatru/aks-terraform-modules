output "vn_id" {
  value = concat(azurerm_virtual_network.main.*.id, [""])[0]
}

output "address_space" { 
  value = concat(azurerm_virtual_network.main.*.address_space, [""])[0]
}

output "name" {
  value = concat(azurerm_virtual_network.main.*.name, [""])[0]

}
