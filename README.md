# Custom AWS vpc module 

## this module is developed for join devops.com we are creating dollowing resources. this module creates first 2 available resources zones for HA.


* VPC 
* Internet gateway 
*  Internet gateway and vpc attachment 
* create 2 - vpc public subnets 
* create 2  -  vpc private subnets 
* create 2  -  vpc data base subnets 
* EIP 
* NAT GW 
* Public Route table
* Private Route table
* Database Route table
* Route tale and subnet Association
* Routes in Association
* Routes in all tables
* Peering if required for user 
* Routes of peering Requestor and Acceptor VPCS 
* create Database subnet group

## Inputs 
* Project name( required ) : use should mention their project name
* Environment ( optional ) : Default value is dev type is string
* command tags (required) :  user should provide comman tags respective their project
* vpc cidr( optional ) : default value is 10.0.0.0/16 Type is string 
* enable_dns_host_name( optional ) :  default value is true type bool
* igw_tags(optional): deafult values are empty
* public_subnet_cidrs(required): default values are ["10.0.1.0/24", "10.0.2.0/24"] type list
* private_subnet_cidrs(required): default values are ["10.0.11.0/24", "10.0.12.0/24"] type list
* database_subnet_cidrs(required): default values are ["10.0.21.0/24", "10.0.22.0/24"] type list
* pulblic_subnet_tags(optional): default value is empty {} type is map
* private_subnet_tags(optional): default value is empty {} type is map
* database_subnet_tags(optional): default value is empty {} type is map

* nat_gateway_tags(optional):  default value is empty {} type is map

* public_route_table_tags(optional) : default value is empty {} type is map
* private_route_table_tags(optional) : default value is empty {} type is map
* database_route_table_tags(optional) : default value is empty {} type is map

* is_peering_required(optional): default value is false type bool
* acceptor_vpc_id(optional): default value is ""
* peering_tags(optional): default value is empty {} type is map
* db_subnet_group_tags(optional): default value is empty {} type is map

## Outputs 
* outputs of one resource become input of another resource
* vpc_id
* public_subnet_ids: a list of 2 subnet resources are added
* private_subnet_ids: a list of 2 subnet resources are added
* database_subnet_ids:  a list of 2 subnet resources are added




