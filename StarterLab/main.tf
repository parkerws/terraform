terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "2.83.0"
        }
    }
}

provider "azurerm" {
    features {
      
    }
}

resource "azurerm_resource_group" "testlab-east2" {
  name = "wparker-test-east2"
  location = var.location-1
  tags = {
    "Owner" = "wparker@redapt.com"
    "CostCenter" = "MDC"
    "Created" : formatdate("DD MMM YYYY", timestamp())
    "Customer": "MDC"
    "BusinessValue": "Test"
  }
}

data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv" {
  depends_on = azurerm_resource_group.testlab-east2
  name = "wparkkv2332"
  location = var.location-1
  resource_group_name = azurerm_resource_group.testlab-east2.name
  enabled_for_disk_encryption = true
  tenant_id = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get"
    ]

    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set"
    ]

    storage_permissions = [
      "get"
    ]
  }
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name = "vmpassword"
  value = "Pa55w.rd1234"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [azurerm_key_vault.kv]
}

resource "azurerm_key_vault_secret" "ansiblepword" {
  name = "ansiblepword"
  value = "Pa55w.rd1234"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [azurerm_key_vault.kv]
}
