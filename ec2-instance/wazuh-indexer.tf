resource "aws_security_group" "wazuh-indexer-sg" {
  name        = "wazuh-indexer-sgp"
  description = "Security group for wazuh indexer"

  vpc_id = var.vpc_id

  ingress {

    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = "false"
  }

  egress {

    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = "false"
  }


  tags = {
    Name = "wazuh-indexer-sgp"
  }
}

resource "tls_private_key" "wazuh-indexer-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "wazuh-indexer-keypair" {
  key_name   = var.ec2-instance.indexer_key_name
  public_key = tls_private_key.wazuh-indexer-key.public_key_openssh
}

resource "aws_eip" "wazuh-indexer-eip" {
  instance = aws_instance.wazuh_indexer.id
  vpc      = true
}


resource "aws_instance" "wazuh_indexer" {
  ami                         = var.ec2-instance.ami
  instance_type               = var.ec2-instance.indexer_instance_type
  key_name                    = aws_key_pair.wazuh-indexer-keypair.key_name
  subnet_id                   = var.public_subnet
  vpc_security_group_ids      = [aws_security_group.wazuh-indexer-sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  depends_on                  = [aws_instance.wazuh_server]
  user_data                   = <<-EOF
    #!/bin/bash
    sudo yum update -y >> /tmp/user_data_output.log 2>&1
    sudo yum install -y curl unzip wget libcap2-bin software-properties-common lsb-release gnupg2 >> /tmp/user_data_output.log 2>&1

    curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh && chmod 744 wazuh-install.sh && bash ./wazuh-install.sh -a >> /tmp/user_data_output.log 2>&1
    sudo yum update -y >> /tmp/user_data_output.log 2>&1

    sudo yum install -y amazon-cloudwatch-agent
    sudo amazon-linux-extras install collectd
    cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json << 'CONFIG'
    {
    "agent": {
        "metrics_collection_interval": 10,
        "run_as_user": "root"
    },
    "logs": {
                "logs_collected": {
                        "files": {
                                "collect_list": [
                                        {
                                                "file_path": "/tmp/user_data_output.log",
                                                "log_group_name": "wazuh-indexer-logs",
                                                "log_stream_name": "{instance_id}",
                                                "retention_in_days": 3
                                        }
                                ]
                        }
                }
        },
    "metrics": {
        "append_dimensions": {
            "AutoScalingGroupName": "$${aws:AutoScalingGroupName}",
            "ImageId": "$${aws:ImageId}",
            "InstanceId": "$${aws:InstanceId}",
            "InstanceType": "$${aws:InstanceType}"
        },
        "metrics_collected": {
            "disk": {
                "measurement": [
                    "used_percent",
                    "disk_used",
                    "disk_free"
                ],
                "metrics_collection_interval": 60,
                "resources": ["/"],
                "totalcpu": false
            },
            "diskio": {
                "measurement": [
                    "io_time",
                    "read_time",
                    "write_time",
                    "diskio_iops_in_progress",
                    "diskio_writes",
                    "diskio_reads"
                ],
                "metrics_collection_interval": 10,
                "resources": ["*"]
            },
            "mem": {
                "measurement": [
                    "mem_used_percent",
                    "mem_available",
                    "mem_used",
                    "mem_cached",
                    "mem_free"
                ],
                "metrics_collection_interval": 60
            },
            "statsd": {
                "metrics_aggregation_interval": 10,
                "metrics_collection_interval": 10,
                "service_address": ":8125"
            },
            "swap": {
                "measurement": [
                    "swap_free",
                    "swap_used",
                    "swap_used_percent"
                ],
                "metrics_collection_interval": 60
            }
        }
    }
}
CONFIG

    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo systemctl restart amazon-cloudwatch-agent
    sudo yum update -y
  EOF


  tags = {
    Name = "rd-wazuh-indexer-sg"
  }
}
