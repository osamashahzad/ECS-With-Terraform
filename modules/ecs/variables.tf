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

variable "terraform_provider_region" {
  description = "region"
  type        = string
}

variable "target_group_arn" {
  description = "target group arn"
  type        = string
}

# variable "private_subnets" {
#   description = "private_subnets"
#   type        = list(string)
# }

variable "private_subnets_ids" {
  description = "private_subnets"
  type        = list(string)
}

variable "container_port" {
  description = "port for container"
  type        = string
}

variable "create_nat_gateway" {
  description = "create nat"
  type        = bool
}

variable "ecs_sg_id" {
  description = "sg of ecs"
  type        = list(string)
}