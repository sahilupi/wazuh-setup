
#wazuh server
output "dashboard_ip" {
  value = module.ec2-instance.dashboard_ip
}

output "dashboard_private_key_pem" {
  value     = module.ec2-instance.dashboard_private_key_pem
  sensitive = true
}

#wazuh indexer
output "indexer_public_ip" {
  value = module.ec2-instance.indexer_public_ip
}

output "indexer_private_key_pem" {
  value     = module.ec2-instance.indexer_private_key_pem
  sensitive = true
}

