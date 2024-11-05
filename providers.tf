provider "azurerm" {
  features {}
  use_cli         = true
  subscription_id = "66f8233a-a46a-4982-89a4-b283434039aa"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  required_version = "~> 1.9.5"
}

