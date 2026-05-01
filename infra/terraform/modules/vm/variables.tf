variable "rg_name" {}
variable "location" {}
variable "suffix" {}
variable "frontend_subnet_id" {}
variable "backend_subnet_id" {}
variable "ops_subnet_id" {}
variable "vm_size" {
  default = "Standard_D2s_v3"
}
variable "frontend_private_ip_address" {
  default = "10.0.1.4"
}
variable "backend_private_ip_address" {
  default = "10.0.2.4"
}
variable "ops_private_ip_address" {
  default = "10.0.4.4"
}
variable "admin_username" {
  default = "azureuser"
}
variable "admin_ssh_public_key" {}
