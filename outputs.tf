output "ipv4_addresses" {
  description = "Public IPv4 addresses of the provisioned servers"
  value       = hcloud_server.agents[*].ipv4_address
}

output "agents" {
  description = "List of provisioned servers"
  value       = hcloud_server.agents[*].name
}