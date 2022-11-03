// Tunnel Public IPs ans PreShared Keys

output "aws_tunnel1_public_ip" {
  value       = aws_vpn_connection.site_to_site.tunnel1_address
  description = "AWS VPN Tunnel 1 Public IP"
}

output "aws_tunnel1_shared_key" {
  value       = aws_vpn_connection.site_to_site.tunnel1_preshared_key
  description = "AWS VPN Tunnel 1 Shared Key"
  sensitive   = true
}

output "aws_tunnel2_public_ip" {
  value       = aws_vpn_connection.site_to_site.tunnel2_address
  description = "AWS VPN Tunnel 2 Public IP"
}

output "aws_tunnel2_shared_key" {
  value       = aws_vpn_connection.site_to_site.tunnel2_preshared_key
  description = "AWS VPN Tunnel 2 Shared Key"
  sensitive   = true
}

