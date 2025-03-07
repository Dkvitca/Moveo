variable "aws_region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "desired_capacity" {}
variable "min_size" {}
variable "max_size" {}
variable "ami_id" {}
variable "init_path" {}