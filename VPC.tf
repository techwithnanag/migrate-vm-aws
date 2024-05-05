######## Provider configuration#####################################
provider "aws" {
  region = "us-west-1"
  #  authenticate AWS API requests 
      # 1. AWS CLI Configuration
      # 2. Setting up Environment Variables
      # 3. Bastion Host
      # 4. Vault for Secure Storage
}

##################### VPC creation  #################################
resource "aws_vpc" "main" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  
  tags = {
    Name = "migrate-vpc"
  }
}

# Create a publuc subnet###
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "puplic-subnet"
  }
}



### create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "migrate-gateway"
  }
}

###Create public route table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
  tags = {
    Name = "public-route"
  }
}




###Route table associations
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}




##############################################################

resource "aws_security_group" "example_sg" {
  name        = "example-security-group"
  description = "Security group allowing SSH, HTTPS, and other specified ports"
  vpc_id      = aws_vpc.main.id

  // Define the ingress rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // Allow traffic from anywhere
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // You might want to restrict this to specific IPs or ranges
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

######################################################################






