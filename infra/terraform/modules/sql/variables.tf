variable "rg_name" {}
variable "location" {}
variable "suffix" {}
variable "data_subnet_id" {}
variable "vnet_id" {}
variable "sql_admin_login" {
  default = "sqladmin"
}
variable "sql_admin_password" {
  sensitive = true
}