#VPC1:
resource "aws_vpc" "TF_DMZ" {
  cidr_block       = "192.168.200.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "TF_DMZ"
  }
}

resource "aws_subnet" "TF_DMZ1" {
  vpc_id = aws_vpc.TF_DMZ.id
  cidr_block = "192.168.200.128/28"

  tags = {
    Name = "TF_DMZ1"
  }
}

resource "aws_vpc" "TF_Secure" {
  cidr_block       = "192.168.201.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "TF_Secure"
  }
}

resource "aws_subnet" "TF_Secure1" {
  vpc_id = aws_vpc.TF_Secure.id
  cidr_block = "192.168.201.128/28"

  tags = {
    Name = "TF_Secure1"
  }
}

# PEERING:
resource "aws_vpc_peering_connection" "TF_secure_dmz" {
  #peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.TF_DMZ.id
  vpc_id        = aws_vpc.TF_Secure.id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between DMZ and Secure"
  }
}

resource "aws_route_table" "peering_routes_a" {
  vpc_id = aws_vpc.TF_DMZ.id

  route {
    cidr_block = aws_vpc.TF_Secure.cidr_block
    gateway_id = aws_vpc_peering_connection.TF_secure_dmz.id
  }
}

resource "aws_route_table" "peering_routes_b" {
  vpc_id = aws_vpc.TF_Secure.id

  route {
    cidr_block = aws_vpc.TF_DMZ.cidr_block
    gateway_id = aws_vpc_peering_connection.TF_secure_dmz.id
  }
}
