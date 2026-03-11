resource "aws_network_interface" "ise_eni" {
  for_each          = { for idx, instance in var.ise_config : idx => instance }
  private_ips       = [each.value.mgmt_ip]
  subnet_id         = each.value.subnet_id
  
  # Drift resolution
  security_groups   = concat(
    [
      aws_security_group.mgmt_sg.id,
      aws_security_group.ise_cluster_communication_sg.id,
      aws_security_group.psn.id
      ],
      var.extra_eni_security_group_ids
  )
  description       = "Management interface for cisco ISE"
  source_dest_check = false

  # Ensure to specify a name for the network interface
  # Here, I'm using the instance's hostname as the interface name
  tags = merge(var.tags, 
    {
      Name = each.value.hostname
    }
  )
}

resource "aws_instance" "ise" {
  for_each      = { for idx, instance in var.ise_config : idx => instance }
  instance_type = each.value.instance_type
  ami           = var.ise_ami
  key_name      = each.value.key_name

  dynamic "network_interface" {
    for_each = range(var.instance_count)
    content {
      network_interface_id = aws_network_interface.ise_eni[each.key].id
      device_index         = 0
    }
  }

  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = var.EBSEncrypt
    volume_size           = each.value.storage_size
    kms_key_id            = var.EBSEncrypt ? var.kms_key_id : null
  }

  tags = merge(var.tags,
    {
      "Name" = each.value.hostname
    }
  )

  volume_tags = merge(var.tags,
    {
      "Name" = "${each.value.hostname}-volume"
    }
  )

  user_data = base64encode(join("\n", [
    "hostname=${each.value.hostname}",
    "dnsdomain=${var.DNSDomain}",
    "primarynameserver=${var.NameServer}",
    "ntpserver=${var.NTPServer}",
    "username=admin",
    "password=${var.password}",
    "timezone=${var.TimeZone}",
    "ersapi=${var.ERSapi}",
    "openapi=${var.OpenAPI}",
    "pxGrid=${each.value.pxGrid}",
    "pxgrid_cloud=${var.PXGridCloud}",
  ]))

  lifecycle {
    ignore_changes = [
      user_data, root_block_device
    ]
  }

}

