terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.11.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#Create VPC
resource "aws_vpc" "vpc_network" {
  cidr_block = "192.168.0.0/23"
}

#Create Internet Gateway
resource "aws_internet_gateway" "gw" {
   vpc_id = aws_vpc.vpc_network.id
}

#Create Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc_network.id

  route {
    cidr_block = var.gateway_address_space
    gateway_id = aws_vpn_gateway.vpn_gateway.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

#Create MGMT Route Table
resource "aws_route_table" "mgmt_route_table" {
  vpc_id = aws_vpc.vpc_network.id
}

#Create Subnets
resource "aws_subnet" "mgmt_subnet" {
  vpc_id = aws_vpc.vpc_network.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "us-east-1a"
}
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc_network.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

# Associate Subnets with Route Table
resource "aws_route_table_association" "mgmt" {
   subnet_id      = aws_subnet.mgmt_subnet.id
   route_table_id = aws_route_table.mgmt_route_table.id
}

resource "aws_route_table_association" "public" {
   subnet_id      = aws_subnet.public_subnet.id
   route_table_id = aws_route_table.route_table.id
}

#Create Security Group
resource "aws_security_group" "my_sg" {
  name   = "my_sg"
  vpc_id = aws_vpc.vpc_network.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create VPN Connection
resource "aws_vpn_connection" "site_to_site" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.my_gateway.id
  type                = "ipsec.1"
  static_routes_only  = true
}

#Create VPN Connection Route
resource "aws_vpn_connection_route" "connection_route" {
  destination_cidr_block = "10.0.0.0/16"
  vpn_connection_id      = aws_vpn_connection.site_to_site.id
}

#Create VPN Gateway
resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.vpc_network.id
}

#Create Customer Gateway
resource "aws_customer_gateway" "my_gateway" {
  bgp_asn    = 65000
  ip_address = var.gateway_ip_address
  type       = "ipsec.1"
}