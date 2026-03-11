variable "instance_count" {
  type    = number
  default = 4
}

variable "aws_region_primary" {
  type    = string
  default = "us-east-1"

}

variable "aws_region_secondary" {
  type    = string
  default = "us-west-2"

}

variable "vpc_name_east" {
  type        = string
  description = "The tag Name of the vpc to deploy to"
  default     = "vpc-01"
}

variable "vpc_name_west" {
  type        = string
  description = "The tag Name of the vpc to deploy to"
  default     = "vpc-02"


}

variable "subnet_cidr_block_east_1" {
  type        = string
  description = " The subnet you want to use"

}

variable "subnet_cidr_block_east_2" {
  type        = string
  description = " The subnet you want to use"

}

variable "subnet_cidr_block_east_3" {
  type        = string
  description = " The subnet you want to use"

}

variable "subnet_cidr_block_east_5" {
  type        = string
  description = "The subnet you want to use"

}

variable "subnet_cidr_block_east_6" {
  type        = string
  description = "The subnet you want to use"

}

variable "subnet_cidr_block_west_1" {
  type        = string
  description = " The subnet you want to use"

}

variable "subnet_cidr_block_west_2" {
  type        = string
  description = " The subnet you want to use"

}

variable "subnet_cidr_block_west_3" {
  type        = string
  description = " The subnet you want to use"

}

variable "subnet_cidr_block_west_5" {
  type        = string
  description = "The subnet you want to use"

}

variable "subnet_cidr_block_west_6" {
  type        = string
  description = "The subnet you want to use"

}

variable "ise_config_east" {
  type = list(object({
    hostname      = string
    mgmt_ip       = string
    key_name      = string
    instance_type = string
    storage_size  = number
    pxGrid        = string
  }))
}

variable "ise_config_west" {
  type = list(object({
    hostname      = string
    mgmt_ip       = string
    key_name      = string
    instance_type = string
    storage_size  = number
    pxGrid        = string
  }))
}

variable "EBSEncrypt" {
  description = "Choose true to enable EBS encryption."
  type        = bool
  default     = true
}

variable "ERSapi" {
  description = "Do you wish to enable ERS?"
  type        = string
  default     = "no"
}

variable "OpenAPI" {
  description = "Do you wish to enable OpenAPI?"
  type        = string
  default     = "no"
}

# variable "PXGrid" {
#   description = "Do you wish to enable pxGrid?"
#   type        = string
#   default     = "no"
# }

variable "PXGridCloud" {
  description = "Do you wish to enable pxGrid Cloud?"
  type        = string
  default     = "no"
}


variable "DNSDomain" {
  description = "Enter a domain name in correct syntax."
  type        = string
  default     = "example.com"
}


variable "NameServer" {
  description = "Enter the IP address of the name server in correct syntax."
  type        = string
  default     = "172.25.15.29"
  validation {
    condition     = can(regex("\\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.|$)){4}\\b", var.NameServer))
    error_message = "Must be a valid IPv4 address for the primary name server. Only single Nameserver is allowed."
  }
}


variable "NTPServer" {
  description = "Enter the IP address or hostname of the NTP server in correct syntax."
  type        = string
  default     = "45.83.234.123"
  validation {
    condition     = can(regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^(?:[A-Fa-f0-9]{1,4}:){7}[A-Fa-f0-9]{1,4}$|^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])(\\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9]))*$", var.NTPServer))
    error_message = "NTP server cannot be empty and only single NTP is allowed."
  }
}


variable "TimeZone" {
  description = "Choose a system time zone."
  type        = string
  default     = "EST"
}

variable "password" {
  description = "Enter a password for the username \"iseadmin\"."
  type        = string
  sensitive   = true
  default     = "JZqwe@byl21ghj"
}
####### NLb###################

variable "nlb_security_group_name" {
  type        = string
  description = "name of security group to apply to nlb"
  default     = "ise_nlb_sg"

}

variable "nlb_name_east" {
  type        = string
  description = "name of nlb in the east"
  default     = "ISEDEV-NLB-EAST"

}

variable "nlb_name_west" {
  type        = string
  description = "name of nlb in the east"
  default     = "ISEDEV-NLB_WEST"

}

variable "ise_aprop_nlb_east" {
  type = object({
    name                             = string
    internal                         = bool
    private_ip_1                     = string
    private_ip_2                     = string
    preserve_client_ip               = bool
    enable_cross_zone_load_balancing = string
    tags                             = map(string)
    listeners = map(object({
      port             = number
      protocol         = string
      target_group_key = string
    }))
  })
}

variable "ise_prop_nlb_east" {
  type = object({
    name                             = string
    internal                         = bool
    private_ip_1                     = string
    private_ip_2                     = string
    preserve_client_ip               = bool
    enable_cross_zone_load_balancing = string
    tags                             = map(string)
    listeners = map(object({
      port             = number
      protocol         = string
      target_group_key = string
    }))
  })
}

variable "ise_ras_nlb_east" {
  type = object({
    name                             = string
    internal                         = bool
    private_ip_1                     = string
    private_ip_2                     = string
    preserve_client_ip               = bool
    enable_cross_zone_load_balancing = string
    tags                             = map(string)
    listeners = map(object({
      port             = number
      protocol         = string
      target_group_key = string
    }))
  })
}

variable "ise_tacacs_nlb_east" {
  type = object({
    name                             = string
    internal                         = bool
    private_ip_1                     = string
    private_ip_2                     = string
    preserve_client_ip               = bool
    enable_cross_zone_load_balancing = string
    tags                             = map(string)
    listeners = map(object({
      port             = number
      protocol         = string
      target_group_key = string
    }))
  })
}

variable "ise_natgw_name_east" {
  description = "The name of the NAT Gateway"
  type        = string
}

variable "ise_natgw_name_use1b" {
  description = "The name of the NAT Gateway"
  type        = string
}

variable "ise_natgw_name_use1c" {
  description = "The name of the NAT Gateway"
  type        = string
}

variable "ise_natgw_private_ip_use1b" {
  description = "The private IP address of the NAT Gateway"
  type        = string
}

variable "ise_natgw_private_ip_use1c" {
  description = "The private IP address of the NAT Gateway"
  type        = string
}

variable "ise_aprop_nlb_west" {
  type = object({
    name                             = string
    internal                         = bool
    private_ip_1                     = string
    private_ip_2                     = string
    preserve_client_ip               = bool
    enable_cross_zone_load_balancing = string
    tags                             = map(string)
    listeners = map(object({
      port             = number
      protocol         = string
      target_group_key = string
    }))
  })
}

variable "ise_prop_nlb_west" {
  type = object({
    name                             = string
    internal                         = bool
    private_ip_1                     = string
    private_ip_2                     = string
    preserve_client_ip               = bool
    enable_cross_zone_load_balancing = string
    tags                             = map(string)
    listeners = map(object({
      port             = number
      protocol         = string
      target_group_key = string
    }))
  })
}

variable "ise_ras_nlb_west" {
  type = object({
    name                             = string
    internal                         = bool
    private_ip_1                     = string
    private_ip_2                     = string
    preserve_client_ip               = bool
    enable_cross_zone_load_balancing = string
    tags                             = map(string)
    listeners = map(object({
      port             = number
      protocol         = string
      target_group_key = string
    }))
  })
}

variable "ise_tacacs_nlb_west" {
  type = object({
    name                             = string
    internal                         = bool
    private_ip_1                     = string
    private_ip_2                     = string
    preserve_client_ip               = bool
    enable_cross_zone_load_balancing = string
    tags                             = map(string)
    listeners = map(object({
      port             = number
      protocol         = string
      target_group_key = string
    }))
  })
}

variable "ise_natgw_name_west" {
  description = "The name of the NAT Gateway"
  type        = string
}

variable "ise_natgw_name_usw2b" {
  description = "The name of the NAT Gateway"
  type        = string
}

variable "ise_natgw_name_usw2c" {
  description = "The name of the NAT Gateway"
  type        = string
}

variable "ise_natgw_private_ip_usw2b" {
  description = "The private IP address of the NAT Gateway"
  type        = string
}

variable "ise_natgw_private_ip_usw2c" {
  description = "The private IP address of the NAT Gateway"
  type        = string
}

