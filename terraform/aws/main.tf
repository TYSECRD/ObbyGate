resource "aws_vpc" "obbygate" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "obbygate-vpc"
    Project     = "ObbyGate"
    Environment = "lab"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.obbygate.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "obbygate-public-1"
    Project     = "ObbyGate"
    Environment = "lab"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.obbygate.id
  cidr_block              = "10.20.11.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "obbygate-private-1"
    Project     = "ObbyGate"
    Environment = "lab"
  }
}

resource "aws_internet_gateway" "obbygate" {
  vpc_id = aws_vpc.obbygate.id

  tags = {
    Name        = "obbygate-igw"
    Project     = "ObbyGate"
    Environment = "lab"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.obbygate.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obbygate.id
  }

  tags = {
    Name        = "obbygate-public-rt"
    Project     = "ObbyGate"
    Environment = "lab"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.obbygate.id

  tags = {
    Name        = "obbygate-private-rt"
    Project     = "ObbyGate"
    Environment = "lab"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "obbygate_app" {
  name        = "obbygate-app-sg"
  description = "Security group for ObbyGate application workloads"
  vpc_id      = aws_vpc.obbygate.id

  ingress = []
  egress  = []

  tags = {
    Name        = "obbygate-app-sg"
    Project     = "ObbyGate"
    Environment = "lab"
  }
}
