variable "rg_name" {}
variable "location" {}
variable "suffix" {}
variable "gateway_subnet_id" {}
variable "frontend_private_ip" {}
variable "backend_private_ip" {}
variable "ops_private_ip" {}
variable "user_assigned_identity_id" {}
variable "enable_https" {}
variable "ssl_certificate_secret_id" {}
variable "frontend_hostname" {
  default = ""
}
