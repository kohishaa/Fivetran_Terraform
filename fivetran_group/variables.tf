variable "region" {
  type = string
}

variable "group_name" {
  type = string
}

variable "fivetran_api_key" {
  type = string
   sensitive = true
}

variable "fivetran_api_secret" {
  type = string
   sensitive = true
} 
