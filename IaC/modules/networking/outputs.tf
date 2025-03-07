output "vpc_id" { value = aws_vpc.my_vpc.id }
output "public_subnets" { value = aws_subnet.public_subnet[*].id }
output "private_subnets" { value = aws_subnet.private_subnet[*].id }
output "alb_sg_id" { value = aws_security_group.alb_sg.id }
output "ec2_sg_id" { value = aws_security_group.ec2_sg.id }
