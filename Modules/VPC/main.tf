# Create Public Subnets
resource "aws_subnet" "public" {
  count             = length(local.public_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = local.public_subnets[count.index].cidr
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = local.public_subnets[count.index].name
  }
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(local.private_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = local.private_subnets[count.index].cidr
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = local.private_subnets[count.index].name
  }
}

# Create Route Tables
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "spaces-prod-public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "spaces-prod-private-route-table"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count      = length(aws_subnet.public)
  subnet_id  = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count      = length(aws_subnet.private)
  subnet_id  = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = 2

  vpc = true
}

# Create NAT Gateways
resource "aws_nat_gateway" "nat" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public[*].id, count.index == 0 ? 0 : 2) # 1st and 3rd public subnets

  tags = {
    Name = "spaces-prod-nat-gateway-${count.index + 1}"
  }
}

# Create Routes for Private Route Table
resource "aws_route" "private" {
  count                  = length(aws_nat_gateway.nat)
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}
