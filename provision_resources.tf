module "vpc" {
  source              = "./modules/vpc"
  env                 = var.env
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  create_nat_gateway  = var.create_nat_gateway
  default_tags        = var.default_tags
  ecs_ports           = var.ecs_ports
}

module "acm" {
  source       = "./modules/acm"
  env          = var.env
  project_name = var.project_name
  default_tags = var.default_tags
  domain_name  = var.domain_name
}

module "ecs" {
  source                    = "./modules/ecs"
  env                       = var.env
  project_name              = var.project_name
  default_tags              = var.default_tags
  terraform_provider_region = var.terraform_provider_region
  create_nat_gateway        = var.create_nat_gateway
  target_group_arn          = module.loadbalancer.target_group_arn
  container_port            = 3000
  # private_subnets = module.vpc.private_subnet_ids
  private_subnets_ids = module.vpc.private_subnet_ids[*]
  ecs_sg_id                 = [module.vpc.ecs_sg_id]
}

module "loadbalancer" {
  source            = "./modules/elb"
  env               = var.env
  project_name      = var.project_name
  default_tags      = var.default_tags
  public_subnet_ids = module.vpc.public_subnet_ids
  sg_id             = module.vpc.lb_sg_id
  vpc_id            = module.vpc.vpc_id
  acm_arn           = module.acm.certificate_arn
}