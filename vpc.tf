resource "aws_vpc" "ships_vpc" {
  cidr_block = local.ships_vpc_cidr

  tags = {
    Name = "ships-vpc"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.ships_vpc.id
  availability_zone = local.az_region
  cidr_block        = "192.168.1.0/24"

  tags = {
    Name = "ships-public-1"
  }
}
