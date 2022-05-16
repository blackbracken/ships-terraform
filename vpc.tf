resource "aws_vpc" "ships_vpc" {
  cidr_block = local.ships_vpc_cidr

  tags = {
    Name = "ships-vpc"
  }
}

resource "aws_internet_gateway" "ships_internet_gateway" {
  vpc_id = aws_vpc.ships_vpc.id

  tags = {
    Name = "ships-internet-gateway"
  }
}

# NAT
resource "aws_eip" "ships_nat_1" {
  vpc = true

  tags = {
    Name = "ships-natgw-1"
  }
}

resource "aws_nat_gateway" "ships_nat_1" {
  subnet_id     = aws_subnet.public_1.id
  allocation_id = aws_eip.ships_nat_1.id

  tags = {
    Name = "ships-1"
  }
}

# public routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ships_vpc.id

  tags = {
    Name = "ships-route-public"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id

  # use internet_gateway to publish
  gateway_id = aws_internet_gateway.ships_internet_gateway.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# private routes
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ships_vpc.id

  tags = {
    Name = "ships-route-private"
  }
}

resource "aws_route" "private_1" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private.id

  # use nat_gateway to hide
  nat_gateway_id = aws_nat_gateway.ships_nat_1.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

# subnets

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.ships_vpc.id
  availability_zone = local.az_region_c
  cidr_block        = "192.168.1.0/24"

  tags = {
    Name = "ships-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.ships_vpc.id
  availability_zone = local.az_region_d
  cidr_block        = "192.168.10.0/24"

  tags = {
    Name = "ships-public-2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.ships_vpc.id
  availability_zone = local.az_region_d
  cidr_block        = "192.168.2.0/24"

  tags = {
    Name = "ships-private-1"
  }
}
