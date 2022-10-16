variable "sp_id" {
  description = "Service Principal application id"
  type = string
  nullable = false
}

variable "usecase_name" {
  description = "Use case name for which the service principal should be created"
  type = string
  nullable = false
}

variable "environment" {
  description = "Environment for which the service principal should be created"
  type = string
  nullable = false
}

variable "token_lifetime_seconds" {
  description = "Lifetime of a service principal token"
  type = number
  nullable = false
  default = 31536000 # 1 year
}
