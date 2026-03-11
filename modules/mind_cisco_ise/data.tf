data "aws_ec2_managed_prefix_list" "netmri" {
  name = "NetMRI"
}

data "aws_ec2_managed_prefix_list" "dnac_forescout" {
  name = "DNA & Forescout"
}

data "aws_ec2_managed_prefix_list" "sai_monitoring" {
  name = "SAI-Monitoring"
}

data "aws_ec2_managed_prefix_list" "ise_nad_clients" {
  name = "ISE NAD Clients"
}

data "aws_ec2_managed_prefix_list" "network_admins" {
  name = "Network admins"
}

data "aws_ec2_managed_prefix_list" "secret_server" {
  name = "Secret Server"
}

data "aws_ec2_managed_prefix_list" "aws_ansible_servers" {
  name = "AWS Ansible Servers"
}

data "aws_ec2_managed_prefix_list" "powerbi" {
  name = "POWERBI"
}

data "aws_ec2_managed_prefix_list" "service_now_mid_servers" {
  name = "Service-Now MID Servers"
}