module "ise_application_east_dev" {
  source = "./modules/mind_cisco_ise"
  providers = {
    aws = aws.east
  }

  #Drift resolution
  extra_eni_security_group_ids = []
  psn_extra_ingress_prefix_list_ids = []
  psn_extra_ingress_cidr_blocks = []


  kms_key_id          = local.kms_key_id_east
  ise_cluster_nodes   = concat(local.modified_ise_config_west["west"], local.modified_ise_config_east["east"])
  vpc_id              = data.aws_vpc.selected_vpc_details_east.id
  region              = substr(var.aws_region_primary, 3, 4)
  security_group_name = "ise_sec_group"
  # Replace with a valid AMI for your environment.
  ise_ami             = "ami-REPLACE_ME_EAST"
  instance_count      = var.instance_count
  EBSEncrypt          = var.EBSEncrypt
  DNSDomain           = var.DNSDomain
  password            = var.password
  TimeZone            = var.TimeZone
  ERSapi              = var.ERSapi
  OpenAPI             = var.OpenAPI
  # PXGrid              = var.PXGrid
  PXGridCloud = var.PXGridCloud
  ise_config  = local.modified_ise_config_east["east"]
  tags = {
    backup = "y"
  }

}

module "ise_application_west_dev" {
  source = "./modules/mind_cisco_ise"
  providers = {
    aws = aws.west
  }

  #Drift resolution
  extra_eni_security_group_ids = []
  psn_extra_ingress_prefix_list_ids = []
  psn_extra_ingress_cidr_blocks = [
    "185.144.241.70/31",
    "185.144.241.38/31",
    "185.144.241.54/31"
  ]


  kms_key_id          = local.kms_key_id_west
  ise_cluster_nodes   = concat(local.modified_ise_config_west["west"], local.modified_ise_config_east["east"])
  vpc_id              = data.aws_vpc.selected_vpc_details_west.id
  region              = substr(var.aws_region_secondary, 3, 4)
  security_group_name = "ise_sec_group"
  # Replace with a valid AMI for your environment.
  ise_ami             = "ami-REPLACE_ME_WEST"
  instance_count      = var.instance_count
  EBSEncrypt          = var.EBSEncrypt
  DNSDomain           = var.DNSDomain
  password            = var.password
  TimeZone            = var.TimeZone
  ERSapi              = var.ERSapi
  OpenAPI             = var.OpenAPI
  # PXGrid              = var.PXGrid
  PXGridCloud = var.PXGridCloud
  ise_config  = local.modified_ise_config_west["west"]

}

output "ise_cluster" {
  value = concat(local.modified_ise_config_west["west"], local.modified_ise_config_east["east"])

}

module "ise_aprop_nlb_east" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nlb"
  version = "1.0.7"
  providers = {
    aws = aws.east
  }

  vpc_id                           = data.aws_vpc.selected_vpc_details_east.id
  name                             = var.ise_aprop_nlb_east.name
  internal                         = var.ise_aprop_nlb_east.internal
  preserve_client_ip               = var.ise_aprop_nlb_east.preserve_client_ip
  enable_cross_zone_load_balancing = var.ise_aprop_nlb_east.enable_cross_zone_load_balancing
  listeners                        = var.ise_aprop_nlb_east.listeners
  subnet_mappings                  = local.ise_aprop_nlb_subnets_east
  target_group                     = local.ise_aprop_nlb_target_group_east
  security_groups                  = [module.ise_application_east_dev.nlb_sg_id]
  tags                             = var.ise_aprop_nlb_east.tags
}

module "ise_prop_nlb_east" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nlb"
  version = "1.0.7"
  providers = {
    aws = aws.east
  }

  vpc_id                           = data.aws_vpc.selected_vpc_details_east.id
  name                             = var.ise_prop_nlb_east.name
  internal                         = var.ise_prop_nlb_east.internal
  preserve_client_ip               = var.ise_prop_nlb_east.preserve_client_ip
  enable_cross_zone_load_balancing = var.ise_prop_nlb_east.enable_cross_zone_load_balancing
  listeners                        = var.ise_prop_nlb_east.listeners
  subnet_mappings                  = local.ise_prop_nlb_subnets_east
  target_group                     = local.ise_prop_nlb_target_group_east
  security_groups                  = [module.ise_application_east_dev.nlb_sg_id]
  tags                             = var.ise_prop_nlb_east.tags
}

module "ise_ras_nlb_east" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nlb"
  version = "1.0.7"
  providers = {
    aws = aws.east
  }

  vpc_id                           = data.aws_vpc.selected_vpc_details_east.id
  name                             = var.ise_ras_nlb_east.name
  internal                         = var.ise_ras_nlb_east.internal
  preserve_client_ip               = var.ise_ras_nlb_east.preserve_client_ip
  enable_cross_zone_load_balancing = var.ise_ras_nlb_east.enable_cross_zone_load_balancing
  listeners                        = var.ise_ras_nlb_east.listeners
  subnet_mappings                  = local.ise_ras_nlb_subnets_east
  target_group                     = local.ise_ras_nlb_target_group_east
  security_groups                  = [module.ise_application_east_dev.nlb_sg_id]
  tags                             = var.ise_ras_nlb_east.tags
}

module "ise_tacacs_nlb_east" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nlb"
  version = "1.0.7"
  providers = {
    aws = aws.east
  }

  vpc_id                           = data.aws_vpc.selected_vpc_details_east.id
  name                             = var.ise_tacacs_nlb_east.name
  internal                         = var.ise_tacacs_nlb_east.internal
  preserve_client_ip               = var.ise_tacacs_nlb_east.preserve_client_ip
  enable_cross_zone_load_balancing = var.ise_tacacs_nlb_east.enable_cross_zone_load_balancing
  listeners                        = var.ise_tacacs_nlb_east.listeners
  subnet_mappings                  = local.ise_tacacs_nlb_subnets_east
  target_group                     = local.ise_tacacs_nlb_target_group_east
  security_groups                  = [module.ise_application_east_dev.nlb_sg_id]
  tags                             = var.ise_tacacs_nlb_east.tags
}

module "ise_nat_gateway_east" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nat-gateway"
  version = "1.0.2"
  providers = {
    aws = aws.east
  }

  nat_gateway_name = var.ise_natgw_name_east
  subnet_mappings  = local.ise_natgw_subnets_east
}

module "ise_aprop_nlb_west" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nlb"
  version = "1.0.7"
  providers = {
    aws = aws.west
  }

  vpc_id                           = data.aws_vpc.selected_vpc_details_west.id
  name                             = var.ise_aprop_nlb_west.name
  internal                         = var.ise_aprop_nlb_west.internal
  preserve_client_ip               = var.ise_aprop_nlb_west.preserve_client_ip
  enable_cross_zone_load_balancing = var.ise_aprop_nlb_west.enable_cross_zone_load_balancing
  listeners                        = var.ise_aprop_nlb_west.listeners
  subnet_mappings                  = local.ise_aprop_nlb_subnets_west
  target_group                     = local.ise_aprop_nlb_target_group_west
  security_groups                  = [module.ise_application_west_dev.nlb_sg_id]
  tags                             = var.ise_aprop_nlb_west.tags
}

module "ise_prop_nlb_west" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nlb"
  version = "1.0.7"
  providers = {
    aws = aws.west
  }

  vpc_id                           = data.aws_vpc.selected_vpc_details_west.id
  name                             = var.ise_prop_nlb_west.name
  internal                         = var.ise_prop_nlb_west.internal
  preserve_client_ip               = var.ise_prop_nlb_west.preserve_client_ip
  enable_cross_zone_load_balancing = var.ise_prop_nlb_west.enable_cross_zone_load_balancing
  listeners                        = var.ise_prop_nlb_west.listeners
  subnet_mappings                  = local.ise_prop_nlb_subnets_west
  target_group                     = local.ise_prop_nlb_target_group_west
  security_groups                  = [module.ise_application_west_dev.nlb_sg_id]
  tags                             = var.ise_prop_nlb_west.tags
}

module "ise_ras_nlb_west" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nlb"
  version = "1.0.7"
  providers = {
    aws = aws.west
  }

  vpc_id                           = data.aws_vpc.selected_vpc_details_west.id
  name                             = var.ise_ras_nlb_west.name
  internal                         = var.ise_ras_nlb_west.internal
  preserve_client_ip               = var.ise_ras_nlb_west.preserve_client_ip
  enable_cross_zone_load_balancing = var.ise_ras_nlb_west.enable_cross_zone_load_balancing
  listeners                        = var.ise_ras_nlb_west.listeners
  subnet_mappings                  = local.ise_ras_nlb_subnets_west
  target_group                     = local.ise_ras_nlb_target_group_west
  security_groups                  = [module.ise_application_west_dev.nlb_sg_id]
  tags                             = var.ise_ras_nlb_west.tags
}

module "ise_tacacs_nlb_west" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nlb"
  version = "1.0.7"
  providers = {
    aws = aws.west
  }

  vpc_id                           = data.aws_vpc.selected_vpc_details_west.id
  name                             = var.ise_tacacs_nlb_west.name
  internal                         = var.ise_tacacs_nlb_west.internal
  preserve_client_ip               = var.ise_tacacs_nlb_west.preserve_client_ip
  enable_cross_zone_load_balancing = var.ise_tacacs_nlb_west.enable_cross_zone_load_balancing
  listeners                        = var.ise_tacacs_nlb_west.listeners
  subnet_mappings                  = local.ise_tacacs_nlb_subnets_west
  target_group                     = local.ise_tacacs_nlb_target_group_west
  security_groups                  = [module.ise_application_west_dev.nlb_sg_id]
  tags                             = var.ise_tacacs_nlb_west.tags
}

module "ise_nat_gateway_west" {
  source  = "app.terraform.io/REPLACE_ORG/terraform-aws-base-modules/aws//modules/terraform-aws-nat-gateway"
  version = "1.0.2"
  providers = {
    aws = aws.west
  }

  nat_gateway_name = var.ise_natgw_name_west
  subnet_mappings  = local.ise_natgw_subnets_west
}

