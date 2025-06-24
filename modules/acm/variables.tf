variable "domain_name" {
  type = string
}

variable "default_tags" {
  description = "Tags for the account"
  type        = map(any)
}

variable "project_name" {
  description = "Name of the Project"
  type        = string
}


variable "env" {
  description = "The name of the environment."
  type        = string
}