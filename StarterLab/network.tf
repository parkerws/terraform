resource "azurerm_virtual_network" "vnet-eu2" {
  name = "wparker-vnet-test-eu2"
  address_space = [var.vnet-address-space-01]
  location = var.location-1
  resource_group_name = azurerm_resource_group.testlab-east2
}

resource "azurerm_subnet" "snet-infra-1" {
  name = "snet-infra-eus2"
  resource_group_name = azurerm_resource_group.testlab-east2
  virtual_network_name = azurerm_virtual_network.vnet-eu2
  address_prefixes = [var.snet-infra-01]
}

resource "azurerm_subnet" "snet-app-1" {
  name = "snet-app-eus2"
  resource_group_name = azurerm_resource_group.testlab-east2
  virtual_network_name = azurerm_virtual_network.vnet-eu2
  address_prefixes = [var.snet-app-01]
}

resource "azurerm_subnet" "snet-db-1" {
  name = "snet-db-eus2"
  resource_group_name = azurerm_resource_group.testlab-east2
  virtual_network_name = azurerm_virtual_network.vnet-eu2
  address_prefixes = [var.snet-infra-01]
}

resource "azurerm_subnet" "snet-iam-1" {
  name = "snet-iam-eus2"
  resource_group_name = azurerm_resource_group.testlab-east2
  virtual_network_name = azurerm_virtual_network.vnet-eu2
  address_prefixes = [var.snet-infra-01]
}



### Secondary region mirroring primary ###
/*
resource "azurerm_virtual_network" "vnet-wu2" {
  name = "wparker-vnet-test-wu2"
  address_space = [var.vnet-address-space-02]
  location = var.location-1
  resource_group_name = azurerm_resource_group.testlab-west2
}

resource "azurerm_subnet" "snet-infra-2" {
  name = "snet-infra-wus2"
  resource_group_name = azurerm_resource_group.testlab-west2
  virtual_network_name = azurerm_virtual_network.vnet-wu2
  address_prefixes = [var.snet-infra-02]
}

resource "azurerm_subnet" "snet-app-2" {
  name = "snet-app-wus2"
  resource_group_name = azurerm_resource_group.testlab-west2
  virtual_network_name = azurerm_virtual_network.vnet-wu2
  address_prefixes = [var.snet-app-02]
}

resource "azurerm_subnet" "snet-db-2" {
  name = "snet-db-wus2"
  resource_group_name = azurerm_resource_group.testlab-west2
  virtual_network_name = azurerm_virtual_network.vnet-wu2
  address_prefixes = [var.snet-db-02]
}

resource "azurerm_subnet" "snet-iam-2" {
  name = "snet-iam-wus2"
  resource_group_name = azurerm_resource_group.testlab-west2
  virtual_network_name = azurerm_virtual_network.vnet-wu2
  address_prefixes = [var.snet-iam-02]
}

resource "azurerm_network_security_group" "nsg-iam" {
  name = "nsg-iam-eus2"
  location = azurerm_resource_group.testlab-east2.location
  resource_group_name = azurerm_resource_group.testlab-east2.name

  security_rule = [ {
    destination_address_prefix = ""
    destination_port_range = "value"
    direction = "value"
    name = "value"
    priority = 100
    protocol = "value"
    source_address_prefix = "value"
    source_port_range = "value"
  } ]
}
*/