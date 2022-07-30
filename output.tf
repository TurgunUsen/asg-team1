output "elb-dns-name" {
  value = aws_lb.application-lb.dns_name
}

# Subnets for Default VPC

data "aws_subnet_ids" "subnet" {
  vpc_id = aws_default_vpc.default.id
}