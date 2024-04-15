#wazuh server
output "dashboard_ip" {
  description = "Contains the public IP address"
  value       = aws_eip.wazuh-server-eip.public_ip
}

output "dashboard_private_key_pem" {
  value = tls_private_key.wazuh-server-key.private_key_pem
}

#wazuh indexer
output "indexer_public_ip" {
  description = "Contains the public IP address"
  value       = aws_eip.wazuh-indexer-eip.public_ip
}

output "indexer_private_key_pem" {
  value = tls_private_key.wazuh-indexer-key.private_key_pem
}

#wazuh agent

output "agent_public_ip" {
  description = "Contains the public IP address"
  value       = aws_eip.wazuh-agent-eip.public_ip
}

output "agent_private_key_pem" {
  value = tls_private_key.wazuh-agent-key.private_key_pem
}

