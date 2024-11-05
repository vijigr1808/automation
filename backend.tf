terraform {
  backend "azurerm" {
    resource_group_name  = "tfstateN01692684RG"
    storage_account_name = "tfstaten01692684sa"
    container_name       = "tfstatefiles"
    key                  = "terraform.tfstate"
  }
}

