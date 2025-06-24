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

variable "sg_id" {
  type        = string
  description = "Load Balancer SG"

}

variable "public_subnet_ids" {
  type        = list(string)
  description = "public subnet ids"
}

variable "vpc_id" {
  type        = string
  description = "VPC id of VPC"
}

variable "acm_arn" {
  type        = string
  description = "ARN of ACM"
}