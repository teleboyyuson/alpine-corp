resource "aws_vpc" "default" {
  cidr_block = var.cidr_blocks[0]
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    terraform = "true"
    Name = "${terraform.workspace}-vpc-${var.vpc_name}"
  }
  
}

resource "aws_subnet" "default" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.cidr_blocks[1]
  availability_zone = var.zone

  tags = {
    terraform = "true"
    Name = "${terraform.workspace}-subnet-${var.vpc_name}" 
  }
  
}