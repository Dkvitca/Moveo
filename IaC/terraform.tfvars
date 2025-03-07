vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]
availability_zones = ["ap-south-1a", "ap-south-1b"]
desired_capacity = 1
min_size = 1
max_size = 2

aws_region = "ap-south-1"
ami_id = "ami-06caa9d39211108fc" # Custom ami.
init_path = "./scripts/init.sh"


