terraform {
  required_providers {
    fivetran = {
      source = "fivetran/fivetran"
      version = ">= 0.7.0"
    }
  }
}

# Configure the Fivetran provider
provider "fivetran" {
    api_key = var.fivetran_api_key
    api_secret = var.fivetran_api_secret
}
provider "aws" {
  region = var.region
  #access_key = var.access_key
  #secret_key = var.secret_key
}