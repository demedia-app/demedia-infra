resource "aws_vpc" "us-west-vpc" {
  provider   = aws.us-west-1
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "us-west_public_subnet" {
  vpc_id            = aws_vpc.us-west-vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name = "US west public subnet"
  }
  provider = aws.us-west-1
}

resource "aws_internet_gateway" "us-west-igw" {
  vpc_id = aws_vpc.us-west-vpc.id

  tags = {
    Name = "us-west-vpc Internet Gateway"
  }
  provider = aws.us-west-1
}

resource "aws_route_table" "west-public_rt" {
  vpc_id = aws_vpc.us-west-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.us-west-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.us-west-igw.id
  }

  route {
    cidr_block                = aws_vpc.us-east-vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-connection.id
  }

  tags = {
    Name = "West Public Route Table"
  }

  provider = aws.us-west-1
}

resource "aws_route_table_association" "west-public_1_rt_a" {
  subnet_id      = aws_subnet.us-west_public_subnet.id
  route_table_id = aws_route_table.west-public_rt.id
  provider       = aws.us-west-1
}

# -------------------------------------------------------------------------

resource "aws_vpc" "us-east-vpc" {
  provider   = aws.us-east-1
  cidr_block = "10.2.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "us-east_public_subnet" {
  vpc_id            = aws_vpc.us-east-vpc.id
  cidr_block        = "10.2.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "US east public subnet"
  }
  provider = aws.us-east-1
}

resource "aws_internet_gateway" "us-east-igw" {
  vpc_id = aws_vpc.us-east-vpc.id

  tags = {
    Name = "us-east-vpc Internet Gateway"
  }
  provider = aws.us-east-1
}

resource "aws_route_table" "east-public_rt" {
  vpc_id = aws_vpc.us-east-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.us-east-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.us-east-igw.id
  }

  route {
    cidr_block                = aws_vpc.us-west-vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-connection.id
  }

  tags = {
    Name = "east Public Route Table"
  }
  provider = aws.us-east-1
}

resource "aws_route_table_association" "east-public_1_rt_a" {
  subnet_id      = aws_subnet.us-east_public_subnet.id
  route_table_id = aws_route_table.east-public_rt.id
  provider       = aws.us-east-1
}
# ---------------------------------------------------------------------

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "vpc-peer-connection" {
  peer_owner_id = "114416785068"
  peer_vpc_id   = aws_vpc.us-east-vpc.id
  vpc_id        = aws_vpc.us-west-vpc.id
  peer_region   = "us-east-1"

  tags = {
    Side = "Requester"
  }

  provider      = aws.us-west-1
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.us-east-1
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-connection.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_vpc_peering_connection_options" "aws_vpc_peering_con_options_requester" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-connection.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [ aws_vpc_peering_connection_accepter.peer ]
  provider   = aws.us-west-1
}

resource "aws_vpc_peering_connection_options" "aws_vpc_peering_con_options_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-connection.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [ aws_vpc_peering_connection_options.aws_vpc_peering_con_options_requester ]
  provider   = aws.us-east-1
}
