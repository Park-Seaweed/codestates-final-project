resource "aws_vpc" "final_terraform" {
  cidr_block = var.vpc

  tags = {
    Name = "final-terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.final_terraform.id
  count             = 2
  cidr_block        = var.public_subnet_cidr_list[count.index]
  availability_zone = var.availability_zone_list[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "final_igw" {
  vpc_id = aws_vpc.final_terraform.id
  tags = {
    Name = "final-igw"
  }
}

resource "aws_route_table" "final_public_rtb" {
  vpc_id = aws_vpc.final_terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.final_igw.id
  }
  tags = {
    Name = "final-public-route-table"
  }
}

resource "aws_route_table_association" "public_rtb_association" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.final_public_rtb.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.final_terraform.id
  count             = 2
  cidr_block        = var.private_subnet_cidr_list[count.index]
  availability_zone = var.availability_zone_list[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "rds_subnet" {
  vpc_id            = aws_vpc.final_terraform.id
  count             = 2
  cidr_block        = var.rds_subnet_cidr_list[count.index]
  availability_zone = var.availability_zone_list[count.index]

  tags = {
    Name = "rds-subnet-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
}



resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_route_table" "final_private_rtb" {
  vpc_id = aws_vpc.final_terraform.id

  tags = {
    Name = "final-private-route-table"
  }
}

resource "aws_route_table" "final_rds_rtb" {
  vpc_id = aws_vpc.final_terraform.id

  tags = {
    Name = "final-rds-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.final_private_rtb.id
}

resource "aws_route_table_association" "rds_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.rds_subnet[count.index].id
  route_table_id = aws_route_table.final_rds_rtb.id
}


resource "aws_route" "private_subnet_route" {
  route_table_id         = aws_route_table.final_private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  depends_on             = [aws_nat_gateway.nat_gateway]
}

resource "aws_route" "rds_subnet_route" {
  route_table_id         = aws_route_table.final_rds_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  depends_on             = [aws_nat_gateway.nat_gateway]
}
