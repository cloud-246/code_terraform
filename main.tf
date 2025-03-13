terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.90.1"
    }
  }
}

provider "aws" {
  region = var.region
}

module "networking" {
  source                  = "./modules/networking"
  cidr_block_vpc          = var.cidr_block_vpc
  public_1_cidr_block     = var.private_1_cidr_block
  private_1_cidr_block    = var.public_1_cidr_block
}

module "security_groups" {
  source                 = "./modules/security_groups"
  bastion_host_sg_name   = "bastion_host_sg"
  lb_sg_name             = "load_balancer_sg"
  vpc_id                 = module.networking.test_vpc_id
  pvt_inst_sg_name       = "private_instance_sg"
}

module "instances" {
  source                   = "./modules/instances"
  public_1_id              = module.networking.public_1_id
  bastion_host_sg_id       = module.security_groups.bastion_host_sg_id
  key_name                 = "public-instance-key"
  ami                      = "ami-020d4adcf360a7fd7"
  private_1_id             = module.networking.private_1_id
  private_instance_sg_id   = module.security_groups.private_instance_sg_id
}

module "load_balancer" {
  source                     = "./modules/load_balancer"
  lb_security_group_id       =  module.security_groups.load_balancer_sg_id
  load_balancer_subnets      =  [module.networking.public_1_id, module.networking.private_1_id]
  tg_vpc_id                  =  module.networking.test_vpc_id
  target_id                  =  module.instances.private_instance_id
  listener_port              = "80"
  listener_protocol          = "HTTP"
}
