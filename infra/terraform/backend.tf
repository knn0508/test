terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-project2-g6"
    storage_account_name = "tfstateproject2g6"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}