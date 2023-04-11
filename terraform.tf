# Configure Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.11.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "<resource group for terraform state file storage>"
    storage_account_name = "<storage account for terraform state file storage>"
    container_name       = "terraform-aztransit-spokes"
    key                  = "<storage account key>"
  }
}