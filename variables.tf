# VPC variables

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"

}

variable "dns_host_name" {
  type    = bool
  default = true

}

variable "vpc_tags" {
  type    = map(any)
  default = {}
}

# project variables 

variable "project_name" {
  type = string

}
variable "environment" {
  type    = string
  default = "dev"
}

variable "comman_tags" {
  type = map(any)

}

# IGW variables

variable "igw_tags" {
  type    = map(any)
  default = {}
}

# pulic subnet variables
variable "public_subnet_cidrs" {
  type = list(any)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "public_subnet_cidrs must contain exactly 2 CIDR blocks."
  }
}
variable "public_subnet_tags" {
  type    = map(any)
  default = {}
}


# private subnet variables
variable "private_subnet_cidrs" {
  type = list(any)

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "private_subnet_cidrs must contain exactly 2 CIDR blocks."
  }
}
variable "private_subnet_tags" {
  type    = map(any)
  default = {}
}


# db subnet variables
variable "database_subnet_cidrs" {
  type = list(any)

  validation {
    condition     = length(var.database_subnet_cidrs) == 2
    error_message = "database_subnet_cidrs must contain exactly 2 CIDR blocks."
  }
}
variable "database_subnet_tags" {
  type    = map(any)
  default = {}
}

#nat gateway variables
variable "nat_gateway_tags" {
  type    = map(any)
  default = {}
}

# public route table variables
variable "public_route_table_tags" {
  type    = map(any)
  default = {}
}
# private route table variables
variable "private_route_table_tags" {
  type    = map(any)
  default = {}
}

# database route table variables
variable "database_route_table_tags" {
  type    = map(any)
  default = {}
}

## peering variables
variable "is_peering_required" {
  type    = bool
  default = false
}

variable "acceptor_vpc_id" {
  type    = string
  default = ""
}
variable "peering_tags" {
  type    = map(any)
  default = {}

}

variable "db_subnet_group_tags" {
  type    = map(any)
  default = {}
}
