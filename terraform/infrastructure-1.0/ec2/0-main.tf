provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "default" {
  cidr_block = var.cidr_blocks[0]

  tags = {
    terraform = "true"
    Name = "${terraform.workspace}-vpc"
  }
  
}

resource "aws_subnet" "default" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.cidr_blocks[1]
  availability_zone = var.zone

  tags = {
    terraform = "true"
    Name = "${terraform.workspace}-subnet"
  }
  
}