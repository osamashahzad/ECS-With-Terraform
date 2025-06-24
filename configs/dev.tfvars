default_tags = {
  "Department" : "DevOps",
  "PrimaryContact" : "test@example.com",
  "Terraform" : "True",
  "ProjectName" : "Test-Sample",
  "Environment" : "dev"
}

terraform_provider_region = "us-east-1"

project_name = "Test-Sample"
env          = "dev"

should_create_vpc = false

vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = ["10.0.0.0/18", "10.0.64.0/18"]
private_subnet_cidr = ["10.0.128.0/18", "10.0.192.0/18"]

create_nat_gateway = false

# This will create ACM only you need to create records in Route53 or your DNS Provider
domain_name = "chapter85.com"

# Ports to expose for ecs sg
ecs_ports = [3000]