aws_region = "ap-southeast-1"

vpc = {
  vpc_cidr                = "10.0.0.0/16"
  availability_zones      = ["ap-southeast-1a", "ap-southeast-1b"]
  enable_dns_support      = "true"
  enable_dns_hostnames    = "true"
  instance_tenancy        = "default"
  enable_ipv6             = "false"
  map_public_ip_on_launch = "true" #set to false then public IP will not associate
  public_subnets          = ["10.0.10.0/24", "10.0.20.0/24"]
}

ec2-instance = {

  ami                                    = "ami-0dcd3bdfd27bf3942"
  server_instance_type                   = "t3.medium"
  agent_instance_type                    = "t3.medium"
  indexer_instance_type                  = "t3.large"
  agent_key_name                         = "wazuh-agent-key"
  server_key_name                        = "wazuh-server-key"
  indexer_key_name                       = "wazuh-indexer-key"
  volume_size                            = 30
  volume_type                            = "gp2"
  encrypted                              = true
  max_size                               = 2
  min_size                               = 1
  desired_capacity                       = 1
  autoscaling_policies_enabled           = true
  cpu_utilization_high_threshold_percent = 80
  cpu_utilization_low_threshold_percent  = 30
}
