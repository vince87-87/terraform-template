resource "aws_vpc" "vpc" {
  cidr_block                     = var.vpc_cidr_block
  instance_tenancy               = var.instance_tenancy
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  tags = merge(
    { "Name" = var.vpc_name },
    var.common_tags,
    var.vpc_tags,
  )
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet" {
  count                                       = length(var.public_subnet)
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.public_subnet[count.index]
  availability_zone                           = data.aws_availability_zones.available.names[count.index]
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = true

  tags = merge(
    { "Name" = join("-", [var.application_name, "public_subnet", data.aws_availability_zones.available.names[count.index]]) },
    var.common_tags,
    var.subnet_tags,
  )
}

resource "aws_subnet" "app_subnet" {
  count                                       = length(var.app_subnet)
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.app_subnet[count.index]
  availability_zone                           = data.aws_availability_zones.available.names[count.index]
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = false

  tags = merge(
    { "Name" = join("-", [var.application_name, "app_subnet", data.aws_availability_zones.available.names[count.index]]) },
    var.common_tags,
    var.subnet_tags,
  )

}

resource "aws_subnet" "db_subnet" {
  count                                       = length(var.db_subnet)
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.db_subnet[count.index]
  availability_zone                           = data.aws_availability_zones.available.names[count.index]
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = false

  tags = merge(
    { "Name" = join("-", [var.application_name, "db_subnet", data.aws_availability_zones.available.names[count.index]]) },
    var.common_tags,
    var.subnet_tags,
  )

}

resource "aws_internet_gateway" "InternetGW" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = var.internetgw_name },
    var.common_tags,
    var.subnet_tags,
  )
}

resource "aws_eip" "eip" {
  count      = var.number_of_eip == null ? length(var.public_subnet) : var.number_of_eip
  vpc        = true
  depends_on = [aws_internet_gateway.InternetGW]

  tags = merge(
    { "Name" = join("-", [var.application_name, "eip", data.aws_availability_zones.available.names[count.index]]) },
    var.common_tags,
  )
}

resource "aws_nat_gateway" "natgw" {
  count             = var.number_of_nat_gateway == null ? length(var.public_subnet) : var.number_of_nat_gateway
  allocation_id     = aws_eip.eip.*.id[count.index]
  connectivity_type = var.nat_connectivity_type
  subnet_id         = element(aws_subnet.public_subnet.*.id, count.index)

  tags = merge(
    { "Name" = join("-", [var.application_name, "nat-gateway", data.aws_availability_zones.available.names[count.index]]) },
    var.common_tags,
  )

  depends_on = [aws_internet_gateway.InternetGW]
}
################PUBLIC-ROUTE-TABLE################
resource "aws_route_table" "public" {
  count  = var.number_of_public_route_table == null ? length(data.aws_availability_zones.available) : var.number_of_public_route_table
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.default_route_destination
    gateway_id = aws_internet_gateway.InternetGW.id
  }

  tags = merge(
    { "Name" = var.pubic_route_table_name },
    var.common_tags,
    var.subnet_tags,
  )
}
##################################################

################APP-ROUTE-TABLE###################
resource "aws_route_table" "app" {
  count  = var.number_of_app_route_table == null ? length(data.aws_availability_zones.available) : var.number_of_app_route_table
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.default_route_destination
    nat_gateway_id = element(aws_nat_gateway.natgw[*].id,count.index)
  }

  tags = merge(
    { "Name" = join("-",[var.app_route_table_name, data.aws_availability_zones.available.names[count.index]]) },
    var.common_tags,
    var.subnet_tags,
  )
}
##################################################

################DB-ROUTE-TABLE####################
resource "aws_route_table" "db" {
  count  = var.number_of_db_route_table == null ? length(data.aws_availability_zones.available) : var.number_of_db_route_table
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.default_route_destination
    nat_gateway_id = element(aws_nat_gateway.natgw[*].id,count.index)
  }

  tags = merge(
    { "Name" = join("-",[var.db_route_table_name, data.aws_availability_zones.available.names[count.index]]) },
    var.common_tags,
    var.subnet_tags,
  )
}
##################################################


resource "aws_route_table_association" "RTB-PUB-Association" {
  count          = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = element(aws_route_table.public[*].id, count.index) 
}

resource "aws_route_table_association" "RTB-APP-Association" {
  count          = var.preferred_number_of_app_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_app_subnets
  subnet_id      = aws_subnet.app_subnet.*.id[count.index]
  route_table_id = element(aws_route_table.app[*].id, count.index) 
}

resource "aws_route_table_association" "RTB-DB-Association" {
  count          = var.preferred_number_of_db_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_db_subnets
  subnet_id      = aws_subnet.db_subnet.*.id[count.index]
  route_table_id = element(aws_route_table.db[*].id, count.index)
}