terraform {
  required_providers {
    fivetran = {
      source = "fivetran/fivetran"
      version = ">=0.7.0"
    }
  }
}
provider "fivetran" {
    api_key = ""
    api_secret = ""
}
provider "aws" {
  region   = ""
  #access_key = var.access_key
  #secret_key = var.secret_key
}