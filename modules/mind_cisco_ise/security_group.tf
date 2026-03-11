resource "aws_ec2_managed_prefix_list" "ise_cluster" {
  name = "ise_cluster"
  address_family = "IPv4"
  max_entries = 50
  tags = {
    Name = "ise_cluster"
  }
}

resource "aws_ec2_managed_prefix_list" "admin" {
  name = "admin"
  address_family = "IPv4"
  max_entries = 50
  tags = {
    Name = "marrnet"
  }
}

resource "aws_ec2_managed_prefix_list_entry" "ise_cluster" {
  for_each          = { for idx, instance in var.ise_cluster_nodes : idx => instance }
  prefix_list_id = aws_ec2_managed_prefix_list.ise_cluster.id
  cidr = "${each.value.mgmt_ip}/32"
  description = each.value.hostname
}

resource "aws_security_group" "ise_cluster_communication_sg" {
  name   = "ise_cluster_communication"
  vpc_id = var.vpc_id

  tags = {
    Name = "ise_cluster_communication"
  }
}

resource "aws_security_group_rule" "ise_cluster_inbound" {
  description    = "Allow all inbound traffic for ise cluster inter-communication"
  type              = "ingress"
  to_port           = 0
  protocol          = "-1"
  prefix_list_ids = [aws_ec2_managed_prefix_list.ise_cluster.id]
  from_port         = 0
  security_group_id = aws_security_group.ise_cluster_communication_sg.id
}

resource "aws_security_group_rule" "ise_cluster_outbound" {
  description    = "Allow all inbound traffic for ise cluster inter-communication"
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  from_port         = 0
  security_group_id = aws_security_group.ise_cluster_communication_sg.id
}

## ==================== ise_sec_group ===================== ##
resource "aws_security_group" "mgmt_sg" {
  name   = var.security_group_name
  vpc_id = var.vpc_id

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_security_group_rule" "sai_monitoring_icmp" {
  description       = "icmp access"
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.sai_monitoring.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "network_admins_icmp" {
  description       = "icmp access"
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.network_admins.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "service_now_icmp" {
  description       = "icmp access"
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.service_now_mid_servers.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "ssh" {
  description       = "ssh access"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.network_admins.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "https" {
  description       = "https access"
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.network_admins.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

 resource "aws_security_group_rule" "sai_monitoring_tcp_161" {
   description       = "Allow SAI Monitoring"
   type              = "ingress"
   from_port         = 161
   to_port           = 161
   protocol          = "tcp"
   prefix_list_ids   = [data.aws_ec2_managed_prefix_list.sai_monitoring.id]
   security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "sai_monitoring_udp_161" {
  description       = "Allow SAI Monitoring"
  type              = "ingress"
  from_port         = 161
  to_port           = 161
  protocol          = "udp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.sai_monitoring.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

 resource "aws_security_group_rule" "dnac_forescout_icmp" {
   description       = "Allow DNA and Forescout traffic to ISE RADIUS deployment"
   type              = "ingress"
   from_port         = 8
   to_port           = 0
   protocol          = "icmp"
   prefix_list_ids   = [data.aws_ec2_managed_prefix_list.dnac_forescout.id]
   security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "dnac_forescout_tcp_9060" {
  description       = "Allow DNA and Forescout traffic to ISE RADIUS deployment"
  type              = "ingress"
  to_port           = 9060
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.dnac_forescout.id]
  from_port         = 9060
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "dnac_forescout_tcp_8910" {
  description       = "Allow DNA and Forescout traffic to ISE RADIUS deployment"
  type              = "ingress"
  to_port           = 8910
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.dnac_forescout.id]
  from_port         = 8910
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "netmri_snmp" {
  description       = "Allow NetMRI to ISE RADIUS deployment"
  type              = "ingress"
  to_port           = 161
  protocol          = "udp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.netmri.id]
  from_port         = 161
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "secret_server_ssh" {
  description       = "Allow Secret Server to rotate breakglass"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.secret_server.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "dnac_forescout_ssh" {
  description       = "Allow DNA and Forescout traffic to ISE RADIUS deployment"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.dnac_forescout.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "ansible_https" {
  description       = "Allow Ansible to access ISE"
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.aws_ansible_servers.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

 resource "aws_security_group_rule" "powerbi_https" {
   description       = "Allow MINDSECURE (GRAFANA) servers to access ISE"
   type              = "ingress"
   to_port           = 443
   from_port         = 443
   protocol          = "tcp"
   prefix_list_ids   = [data.aws_ec2_managed_prefix_list.powerbi.id]
   security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "dnac_forescout_https" {
  description       = "Allow DNA and Forescout HTTPS traffic to ISE RADIUS deployment"
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.dnac_forescout.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "dnac_forescout_tcp_5222" {
  description       = "Allow DNA and Forescout traffic to ISE RADIUS deployment"
  type              = "ingress"
  to_port           = 5222
  from_port         = 5222
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.dnac_forescout.id]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "network_admins_tcp_8443" {
  description       = "For SAML by network admins"
  type              = "ingress"
  to_port           = 8443
  from_port         = 8443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.network_admins.id]
  security_group_id = aws_security_group.mgmt_sg.id
}
## ======================================================== ##

resource "aws_security_group" "ise_nlb" {
  name   = "ise_nlb_communication"
  vpc_id = var.vpc_id

  ingress {
    description    = "RADIUS Authentication and Accounting (UDP)"
    from_port   = 1812
    to_port     = 1813
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "RADIUS Authentication Accounting (UDP)"
    from_port   = 1645
    to_port     = 1646
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow all inbound traffic for tacacs authentication"
    from_port   = 49
    to_port     = 49
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow ICMP access to endpoints"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ise_nlb_communication"
  }
}

resource "aws_security_group" "psn" {
  name   = "ise_psn_sg"
  vpc_id = var.vpc_id

  #Drift resolution
  dynamic "ingress" {
    for_each = length(var.psn_extra_ingress_prefix_list_ids) > 0 ? [1] : []
    content {
      description    = "ElevenOS PROD Testing"
      from_port   = 1812
      to_port     = 1813
      protocol    = "udp"
      prefix_list_ids  = var.psn_extra_ingress_prefix_list_ids
    }
  }

  dynamic "ingress" {
    for_each = length(var.psn_extra_ingress_cidr_blocks) > 0 ? [1] : []
    content {
      description    = ""
      from_port   = 1812
      to_port     = 1813
      protocol    = "udp"
      prefix_list_ids  = var.psn_extra_ingress_cidr_blocks
    }
  }

  ingress {
    description    = "RADIUS Authentication and Accounting (UDP)"
    from_port   = 1812
    to_port     = 1813
    protocol    = "udp"
    security_groups  = [aws_security_group.ise_nlb.id]
  }
  ingress {
    description    = "RADIUS Authentication Accounting (UDP)"
    from_port   = 1645
    to_port     = 1646
    protocol    = "udp"
    security_groups  = [aws_security_group.ise_nlb.id]
  }
  ingress {
    description    = "Allow all inbound traffic for tacacs authentication"
    from_port   = 49
    to_port     = 49
    protocol    = "tcp"
    security_groups  = [aws_security_group.ise_nlb.id]
  }
  ingress {
    description    = "Allow all inbound traffic for tacacs authentication (ISE NAD clients)"
    from_port   = 49
    to_port     = 49
    protocol    = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.ise_nad_clients.id]
  }
  tags = {
    Name = "ise_psn_sg"
  }
}