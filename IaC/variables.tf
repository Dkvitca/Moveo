variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AWS availability zones to use"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instances in the Auto Scaling Group"
}

variable "min_size" {
  type        = number
  description = "Minimum number of instances in the Auto Scaling Group"
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in the Auto Scaling Group"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instances"
}

variable "init_path" {
  type        = string
  description = "Path to the user data initialization script"
}
