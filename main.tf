module "ec2-instance" {
  source        = "./ec2-instance"
  ec2-instance  = var.ec2-instance
  aws_region    = var.aws_region
  vpc_id        = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnet_0
}

module "vpc" {
  source     = "./vpc"
  vpc        = var.vpc
  aws_region = var.aws_region
}
