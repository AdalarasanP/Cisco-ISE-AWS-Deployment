
locals {

  sandbox1_account_id            = "111111111111"
  sandbox2_account_id            = "222222222222"
  sandbox3_account_id            = "333333333333"
  network_perf_account_id        = "444444444444"
  network_shared_prod_account_id = "555555555555"
  aws_role_name                  = "replace-terraform-role"

  environment     = "prod"
  kms_key_id_east = data.aws_ebs_default_kms_key.current.key_arn
  kms_key_id_west = data.aws_ebs_default_kms_key.current_west.key_arn

  subnet_id_east_1 = data.aws_subnet.selected_subnet_east_1.id
  subnet_id_east_2 = data.aws_subnet.selected_subnet_east_2.id
  subnet_id_east_3 = data.aws_subnet.selected_subnet_east_3.id
  subnet_id_east_5 = data.aws_subnet.selected_subnet_east_5.id
  subnet_id_east_6 = data.aws_subnet.selected_subnet_east_6.id
  subnet_id_west_1 = data.aws_subnet.selected_subnet_west_1.id
  subnet_id_west_2 = data.aws_subnet.selected_subnet_west_2.id
  subnet_id_west_3 = data.aws_subnet.selected_subnet_west_3.id
  subnet_id_west_5 = data.aws_subnet.selected_subnet_west_5.id
  subnet_id_west_6 = data.aws_subnet.selected_subnet_west_6.id
}




# Create modified ise_config with subnet_id added
locals {
  modified_ise_config_east = {
    east = [
      for instance in var.ise_config_east :
      {
        hostname      = instance.hostname
        mgmt_ip       = instance.mgmt_ip
        key_name      = instance.key_name
        instance_type = instance.instance_type
        storage_size  = instance.storage_size
        pxGrid        = instance.pxGrid
        subnet_id = (can(cidrhost(var.subnet_cidr_block_east_1, tonumber(split(".", instance.mgmt_ip)[3]) - tonumber(split("/", split(".", var.subnet_cidr_block_east_1)[3])[0]))) ? local.subnet_id_east_1 :
          can(cidrhost(var.subnet_cidr_block_east_2, tonumber(split(".", instance.mgmt_ip)[3]) - tonumber(split("/", split(".", var.subnet_cidr_block_east_2)[3])[0]))) ? local.subnet_id_east_2 :
          can(cidrhost(var.subnet_cidr_block_east_3, tonumber(split(".", instance.mgmt_ip)[3]) - tonumber(split("/", split(".", var.subnet_cidr_block_east_3)[3])[0]))) ? local.subnet_id_east_3 :
          null
        )
      }
    ]
  }
  modified_ise_config_west = {
    west = [
      for instance in var.ise_config_west :
      {
        hostname      = instance.hostname
        mgmt_ip       = instance.mgmt_ip
        key_name      = instance.key_name
        instance_type = instance.instance_type
        storage_size  = instance.storage_size
        pxGrid        = instance.pxGrid
        subnet_id = (can(cidrhost(var.subnet_cidr_block_west_1, tonumber(split(".", instance.mgmt_ip)[3]) - tonumber(split("/", split(".", var.subnet_cidr_block_west_1)[3])[0]))) ? local.subnet_id_west_1 :
          can(cidrhost(var.subnet_cidr_block_west_2, tonumber(split(".", instance.mgmt_ip)[3]) - tonumber(split("/", split(".", var.subnet_cidr_block_west_2)[3])[0]))) ? local.subnet_id_west_2 :
          can(cidrhost(var.subnet_cidr_block_west_3, tonumber(split(".", instance.mgmt_ip)[3]) - tonumber(split("/", split(".", var.subnet_cidr_block_west_3)[3])[0]))) ? local.subnet_id_west_3 :
          null
        )
      }
    ]
  }
  ise_tac_psn_instances_east = { for instance in module.ise_application_east_dev.instance_info : instance.hostname => instance if can(regex("TACPSN", instance.hostname)) }
  ise_tac_psn_instances_west = { for instance in module.ise_application_west_dev.instance_info : instance.hostname => instance if can(regex("TACPSN", instance.hostname)) }
  ise_rad_psn_instances_east = { for instance in module.ise_application_east_dev.instance_info : instance.hostname => instance if can(regex("RADPSN", instance.hostname)) }
  ise_rad_psn_instances_west = { for instance in module.ise_application_west_dev.instance_info : instance.hostname => instance if can(regex("RADPSN", instance.hostname)) }
}

locals {
  # us-east-1
  ise_aprop_nlb_subnets_east = [
    {
      subnet_id            = local.subnet_id_east_5
      private_ipv4_address = var.ise_aprop_nlb_east.private_ip_1
    },
    {
      subnet_id            = local.subnet_id_east_6
      private_ipv4_address = var.ise_aprop_nlb_east.private_ip_2
    },
  ]
  ise_aprop_nlb_target_group_east = {
    "1812-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_east :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1812
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
    "1813-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_east :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1813
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
  }
  ise_prop_nlb_subnets_east = [
    {
      subnet_id            = local.subnet_id_east_5
      private_ipv4_address = var.ise_prop_nlb_east.private_ip_1
    },
    {
      subnet_id            = local.subnet_id_east_6
      private_ipv4_address = var.ise_prop_nlb_east.private_ip_2
    },
  ]
  ise_prop_nlb_target_group_east = {
    "1812-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_east :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1812
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
    "1813-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_east :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1813
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
  }
  ise_ras_nlb_subnets_east = [
    {
      subnet_id            = local.subnet_id_east_5
      private_ipv4_address = var.ise_ras_nlb_east.private_ip_1
    },
    {
      subnet_id            = local.subnet_id_east_6
      private_ipv4_address = var.ise_ras_nlb_east.private_ip_2
    },
  ]
  ise_ras_nlb_target_group_east = {
    "1812-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_east :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1812
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
    "1813-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_east :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1813
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
  }
  ise_tacacs_nlb_subnets_east = [
    {
      subnet_id            = local.subnet_id_east_5
      private_ipv4_address = var.ise_tacacs_nlb_east.private_ip_1
    },
    {
      subnet_id            = local.subnet_id_east_6
      private_ipv4_address = var.ise_tacacs_nlb_east.private_ip_2
    },
  ]
  ise_tacacs_nlb_target_group_east = {
    "49-TCP" = {
      targets = [
        for hostname, instance in local.ise_tac_psn_instances_east :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 49
      protocol    = "TCP"
      hc_port     = 49
      hc_protocol = "TCP"
      hc_path     = null
    }
  }
  ise_natgw_subnets_east = [
    {
      name       = var.ise_natgw_name_use1b
      subnet_id  = local.subnet_id_east_5
      private_ip = var.ise_natgw_private_ip_use1b
    },
    {
      name       = var.ise_natgw_name_use1c
      subnet_id  = local.subnet_id_east_6
      private_ip = var.ise_natgw_private_ip_use1c
    },
  ]
  # us-west-2
  ise_aprop_nlb_subnets_west = [
    {
      subnet_id            = local.subnet_id_west_5
      private_ipv4_address = var.ise_aprop_nlb_west.private_ip_1
    },
    {
      subnet_id            = local.subnet_id_west_6
      private_ipv4_address = var.ise_aprop_nlb_west.private_ip_2
    },
  ]
  ise_aprop_nlb_target_group_west = {
    "1812-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_west :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1812
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
    "1813-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_west :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1813
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
  }
  ise_prop_nlb_subnets_west = [
    {
      subnet_id            = local.subnet_id_west_5
      private_ipv4_address = var.ise_prop_nlb_west.private_ip_1
    },
    {
      subnet_id            = local.subnet_id_west_6
      private_ipv4_address = var.ise_prop_nlb_west.private_ip_2
    },
  ]
  ise_prop_nlb_target_group_west = {
    "1812-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_west :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1812
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
    "1813-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_west :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1813
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
  }
  ise_ras_nlb_subnets_west = [
    {
      subnet_id            = local.subnet_id_west_5
      private_ipv4_address = var.ise_ras_nlb_west.private_ip_1
    },
    {
      subnet_id            = local.subnet_id_west_6
      private_ipv4_address = var.ise_ras_nlb_west.private_ip_2
    },
  ]
  ise_ras_nlb_target_group_west = {
    "1812-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_west :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1812
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
    "1813-UDP" = {
      targets = [
        for hostname, instance in local.ise_rad_psn_instances_west :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 1813
      protocol    = "UDP"
      hc_port     = 443
      hc_protocol = "TCP"
      hc_path     = null
    }
  }
  ise_tacacs_nlb_subnets_west = [
    {
      subnet_id            = local.subnet_id_west_5
      private_ipv4_address = var.ise_tacacs_nlb_west.private_ip_1
    },
    {
      subnet_id            = local.subnet_id_west_6
      private_ipv4_address = var.ise_tacacs_nlb_west.private_ip_2
    },
  ]
  ise_tacacs_nlb_target_group_west = {
    "49-TCP" = {
      targets = [
        for hostname, instance in local.ise_tac_psn_instances_west :
        {
          id = instance.id
        }
      ]
      target_type = "instance"
      port        = 49
      protocol    = "TCP"
      hc_port     = 49
      hc_protocol = "TCP"
      hc_path     = null
    }
  }
  ise_natgw_subnets_west = [
    {
      name       = var.ise_natgw_name_usw2b
      subnet_id  = local.subnet_id_west_5
      private_ip = var.ise_natgw_private_ip_usw2b
    },
    {
      name       = var.ise_natgw_name_usw2c
      subnet_id  = local.subnet_id_west_6
      private_ip = var.ise_natgw_private_ip_usw2c
    },
  ]
}

