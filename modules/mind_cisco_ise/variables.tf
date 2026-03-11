variable "instance_count" {
  type    = number
  default = 4
}

variable "ise_cluster_nodes" {
  type        = list(any)
  description = "list of ise cluster ip addresses and hostnames"
}

variable "ise_config" {
  type = list(object({
    hostname      = string
    mgmt_ip       = string
    key_name      = string
    instance_type = string
    subnet_id     = string
    storage_size  = number
    pxGrid        = string
  }))

}

variable "vpc_id" {
  type        = string
  description = "The id  of the vpc to deploy to"
}

variable "ise_ami" {
  type        = string
  description = "ami of the aws image that will be used"

}

variable "region" {
  type        = string
  description = "value of the region to deploy too"

}

variable "security_group_name" {
  type        = string
  description = "id of the security group to apply to eni"

}

variable "EBSEncrypt" {
  description = "Choose true to enable EBS encryption."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Enter the KMS Key Id/ARN/Alias for encryption (Applicable only if EBSEncryption is \"true\")"
  type        = string
}

# variable "Hostname" {
#   description = "Enter the hostname."
#   type        = string
#   default     = ""
#   validation {
#     condition     = can(regex("^[a-zA-Z0-9-]{1,19}$", var.Hostname))
#     error_message = "This field only supports alphanumeric characters and hyphen (-). Hostname should not be more than 19 characters."
#   }
# }

variable "DNSDomain" {
  description = "Enter a domain name in correct syntax."
  type        = string
  default     = "example.com"
  # validation {
  #   condition     = can(regex("^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\\.)+[A-Za-z]{2,6}$", var.DNSDomain))
  #   error_message = "Cannot be an IP address. Valid characters include ASCII characters, any numerals, the hyphen (-), and the period (.) for DNS domain."
  # }
}

variable "NameServer" {
  description = "Enter the IP address of the name server in correct syntax."
  type        = string
  default     = "8.8.8.8"
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
  # validation {
  #   condition = can(regex("^((?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@~*!,+=_-])(?!.*?[iI]{1}[sS]{1}[eE]{1}[aA]{1}[dD]{1}[mM]{1}[iI]{1}[nN]{1})(?!.*?[nN]{1}[iI]{1}[mM]{1}[dD]{1}[aA]{1}[eE]{1}[sS]{1}[iI]{1})(?!.*?[cC]{1}[iI]{1}[sS]{1}[cC]{1}[oO]{1})(?!.*?[oO]{1}[cC]{1}[sS]{1}[iI]{1}[cC]{1})|(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?!.*?[iI]{1}[sS]{1}[eE]{1}[aA]{1}[dD]{1}[mM]{1}[iI]{1}[nN]{1})(?!.*?[nN]{1}[iI]{1}[mM]{1}[dD]{1}[aA]{1}[eE]{1}[sS]{1}[iI]{1})(?!.*?[cC]{1}[iI]{1}[sS]{1}[cC]{1}[oO]{1})(?!.*?[oO]{1}[cC]{1}[sS]{1}[iI]{1}[cC]{1})).{8,25}$", var.password))
  #   error_message = "The password must contain a minimum of 8 and maximum of 25 characters, and must include at least one numeral, one uppercase letter, and one lowercase letter. Password should not be the same as username or its reverse (iseadmin or nimdaesi) or (cisco or ocsic). Allowed Special Characters @~*!,+=_-"
  # }
}

variable "username" {
  type        = string
  description = "default username for server"
  default     = "iseadmin"

}


variable "ConfirmPwd" {
  description = "Retype Password."
  type        = string
  sensitive   = true
  default     = ""
}

variable "ERSapi" {
  description = "Do you wish to enable ERS?"
  type        = string
  default     = "yes"
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

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

#Drift resolution
variable "extra_eni_security_group_ids" {
  description = "Additional SG IDs manually attached to the ISE ENIs"
  type = list(string)
  default = []
}

variable "psn_extra_ingress_prefix_list_ids" {
  description = "Additional PL IDs to allow into PSN SG"
  type = list(string)
  default = []
}

variable "psn_extra_ingress_cidr_blocks" {
  description = "Additional CIDR Blocks to allow into PSN SH"
  type = list(string)
  default = []
}
