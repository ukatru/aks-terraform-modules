output "subnet_id" {
  value = azurerm_subnet.target_subnets.id 
}

output "name" {
    value = azurerm_subnet.target_subnets.name 
}
