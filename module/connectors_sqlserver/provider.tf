terraform {
  required_providers {
    fivetran = {
      source = "fivetran/fivetran"
      version = "1.4.1"
    }
  }
}

provider "fivetran" {
    api_key = ""
    api_secret = ""
}