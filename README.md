# Terraform No-Code Module to Deploy and Setup AWS VPC/VPN Resources for On-Prem Connectivity


# Required Inputs:


Gateway IP Space


Gateway IP Address


# Outputs:


AWS VPN Tunnel 1 Public IP


AWS VPN Tunnel 1 Shared Key


AWS VPN Tunnel 2 Public IP


AWS VPN Tunnel 2 Shared Key


# This Module Defines 13 Resources:


aws_customer_gateway.my_gateway


aws_internet_gateway.gw


aws_route_table.mgmt_route_table


aws_route_table.route_table


aws_route_table_association.mgmt


aws_route_table_association.public


aws_security_group.my_sg


aws_subnet.mgmt_subnet


aws_subnet.public_subnet


aws_vpc.vpc_network


aws_vpn_connection.site_to_site


aws_vpn_connection_route.connection_route


aws_vpn_gateway.vpn_gateway


aws_tunnel1_public_ip
