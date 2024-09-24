# Subnet for private compute like ECS / Lambda
resource "aws_subnet" "compute" {
  count             = var.az_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${local.tags.Project}: Compute Subnet ${count.index + 1}"
  }
}


# Route Tables
resource "aws_route_table" "private_compute" {
  count  = var.enable_multi_nat ? var.az_count : 1
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "${local.tags.Project}: Private Compute Route Table ${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_compute" {
  count          = var.az_count
  subnet_id      = aws_subnet.compute[count.index].id
  route_table_id = var.enable_multi_nat ? aws_route_table.private_compute[count.index].id : aws_route_table.private_compute[0].id
}