variable "workspace_id" {
  description = "Workspace id"
  type = string
  nullable = false
}

variable "group" {
  description = "Principal name (user / group / service principal) that should be assigned as user to the workspace"
  type = string
  nullable = false
}

variable "is_admin" {
  description = "should the principal be added as admin or user to the worksapces"
  type = bool
  nullable = false
  default = false
}

