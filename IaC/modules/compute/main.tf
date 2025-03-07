# IAM Role for EC2 to Access ECR
resource "aws_iam_role" "ec2_role" {
  name = "EC2ECRAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AWS-Managed ECR Policy
resource "aws_iam_role_policy_attachment" "ecr_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "s3_fulll_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.ec2_role.name
}


# Create IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2ECRInstanceProfile"
  role = aws_iam_role.ec2_role.name
}

# ALB
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets
  tags = {
    Name = "nginx-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "nginx_tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    Name = "nginx-tg"
  }
}

# Listener
resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action { 
    type = "forward" 
    target_group_arn = aws_lb_target_group.nginx_tg.arn 
  }
}

# Launch Template with IAM Role for ECR
resource "aws_launch_template" "nginx_lt" {
  name_prefix   = "nginx-lt"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces { security_groups = [var.ec2_sg_id] }

  user_data = base64encode(file(var.init_path))
}

# Auto Scaling Group
resource "aws_autoscaling_group" "nginx_asg" {
  desired_capacity     = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.private_subnets

  launch_template { 
    id = aws_launch_template.nginx_lt.id 
    version = "$Latest" 
  }

  target_group_arns = [aws_lb_target_group.nginx_tg.arn]
}
