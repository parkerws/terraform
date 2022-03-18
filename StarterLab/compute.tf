resource "azurerm_public_ip" "dc1pip" {
  name = "dc1pip"
  resource_group_name = azurerm_resource_group.testlab-east2.name
  location = azurerm_resource_group.testlab-east2.location
  sku = "basic"
}


resource "azurerm_network_interface" "dc1nic" {
  name                = "dc1nic"
  location            = azurerm_resource_group.testlab-east2.location
  resource_group_name = azurerm_resource_group.testlab-east2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-iam-1.id
    private_ip_address_allocation = "Static"
    public_ip_address_id = azurerm_public_ip.dc1pip.id
  }
}

resource "azurerm_windows_virtual_machine" "dc01" {
  name                = "EUSDC01"
  resource_group_name = azurerm_resource_group.testlab-east2.name
  location            = azurerm_resource_group.testlab-east2.location
  size                = "Standard_D2_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.dc1nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "dc1-init" {
  name = "dc1-init"
  virtual_machine_id = azurerm_windows_virtual_machine.dc01
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "2.0"

  
}

resource "azurerm_network_interface" "ctx1nic" {
  name                = "ctx1nic"
  location            = azurerm_resource_group.testlab-east2.location
  resource_group_name = azurerm_resource_group.testlab-east2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-app-1.id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_windows_virtual_machine" "ctx01" {
  name                = "EUSCTX01"
  resource_group_name = azurerm_resource_group.testlab-east2.name
  location            = azurerm_resource_group.testlab-east2.location
  size                = "Standard_D2_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.dc2nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "ctx2nic" {
  name                = "ctx2nic"
  location            = azurerm_resource_group.testlab-east2.location
  resource_group_name = azurerm_resource_group.testlab-east2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-app-1.id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_windows_virtual_machine" "ctx02" {
  name                = "EUSCTX02"
  resource_group_name = azurerm_resource_group.testlab-east2.name
  location            = azurerm_resource_group.testlab-east2.location
  size                = "Standard_D2_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.dc2nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "ans1pip" {
  name = "ans1pip"
  resource_group_name = azurerm_resource_group.testlab-east2.name
  location = azurerm_resource_group.testlab-east2.location
  sku = "basic"
}

resource "azurerm_network_interface" "ansible1nic" {
  name                = "ans1nic"
  location            = azurerm_resource_group.testlab-east2.location
  resource_group_name = azurerm_resource_group.testlab-east2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-infra-1.id
    private_ip_address_allocation = "Static"
    public_ip_address_id = azurerm_public_ip.ans1pip.id
  }
}

resource "azurerm_windows_virtual_machine" "ansible1" {
  name                = "EUSANS01"
  resource_group_name = azurerm_resource_group.testlab-east2.name
  location            = azurerm_resource_group.testlab-east2.location
  size                = "Standard_D2_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.dc2nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}