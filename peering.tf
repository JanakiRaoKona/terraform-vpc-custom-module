resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0

  vpc_id      = aws_vpc.main.id                                                           # requester VPC ID
  peer_vpc_id = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id : var.acceptor_vpc_id # accepter VPC ID
  auto_accept = var.acceptor_vpc_id == "" ? true : false

  tags = merge(
    var.comman_tags,
    var.peering_tags,
    { Name = "${local.resource_name}" }
  )
}

#count is useful to control when resource should be created or not. here we are creating peering connection resource only when is_peering_required variable is true. if its false then count will be 0 and resource will not be created.
# ROUTES of public route
## if count is set by defaukt its 0 so we can accces through index 0
resource "aws_route" "public_route-peering" {
  count                     = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# ROUTES of private route 
resource "aws_route" "private_route_peering" {
  count                     = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# ROUTES of database route 
resource "aws_route" "database_route_peering" {
  count                     = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# default route peering 
resource "aws_route" "default_route_peering" {
  count                     = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.vpc_cidr # we can use any cidr block of requester vpc because its default route and it will route all traffic to peering connection
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}
