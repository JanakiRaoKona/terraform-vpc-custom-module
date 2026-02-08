resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = var.dns_host_name

  tags = merge(
    var.comman_tags,
    var.vpc_tags,
    {
      Name = local.resource_name
    }
  )
}
# internet gateway resource
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id # here vpc is associated with internet gateway.

  tags = merge(
    var.comman_tags,
    var.igw_tags,
    {
      Name = local.resource_name
    }
  )
}

# public subnet resources 

resource "aws_subnet" "public" { # public[0] public[1]
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true # just opnened pulic internet gateway for public subnet. so that we can access internet from public subnet.

  tags = merge(
    var.comman_tags,
    var.public_subnet_tags,
    {
      Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}


# private subnet resources 

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = false # private subnet does not have public ip address. just for understanding write here  default its false.

  tags = merge(
    var.comman_tags,
    var.private_subnet_tags,
    {
      Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}


# private subnet resources 

resource "aws_subnet" "database" {
  count                   = length(var.database_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.database_subnet_cidrs[count.index]
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = false # private subnet does not have public ip address. just for understanding write here y default its false.

  tags = merge(
    var.comman_tags,
    var.database_subnet_tags,
    {
      Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )
}

# aws elastic ip resource for nat gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# nat gateway resource
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.comman_tags,
    var.nat_gateway_tags,
    {
      Name = "${local.resource_name}" #here Name expense dev is coming in nat gateway 
    }
  )
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# public route table resource
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.comman_tags,
    var.public_route_table_tags,
    {
      Name = "${local.resource_name}-public"
    }
  )


}
# private route table resource
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.comman_tags,
    var.private_route_table_tags,
    {
      Name = "${local.resource_name}-private"
    }
  )


}

# database route table resource
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.comman_tags,
    var.database_route_table_tags,
    {
      Name = "${local.resource_name}-database"
    }
  )


}

# ROUTES of public route table
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# ROUTES of private route table
resource "aws_route" "private_route-nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# ROUTES of database route table
resource "aws_route" "database_route-nat" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
# route table and subnet association 

# route table association for public subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

# route table association for private subnet
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

# route table association for database subnet
resource "aws_route_table_association" "database" {
  count          = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}


resource "aws_db_subnet_group" "default" {
  name       = local.resource_name
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.comman_tags,
    var.db_subnet_group_tags,
    {
      Name = "${local.resource_name}"
    }
  )
}
