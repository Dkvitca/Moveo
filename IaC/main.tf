
module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr 
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.availability_zones
  aws_region           = var.aws_region 
}  

module "compute" {
  source            = "./modules/compute"
  vpc_id            = module.networking.vpc_id 
  public_subnets    = module.networking.public_subnets
  private_subnets   = module.networking.private_subnets
  alb_sg_id         = module.networking.alb_sg_id
  ec2_sg_id         = module.networking.ec2_sg_id
  desired_capacity  = var.desired_capacity
  min_size          = var.min_size
  max_size          = var.max_size
  ami_id            = var.ami_id
  init_path         = var.init_path

  depends_on = [ module.networking ]
}
