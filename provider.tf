terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.80.0"
    }
  }
}

provider "aws" {
  region = var.aws_region_primary
  alias  = "east"

  default_tags {
    tags = merge(
      {
        dud          = "REPLACE_DUD"
        department   = "PlatformEngineering"
        managedby    = "Terraform"
        environment  = local.environment
        location     = "aws-us-east-1"
        accenture_ru = "n"
        owner        = "replace-owner"
        createdby    = "replace-createdby"
        project      = "ISE Deployment"
        nonGamiEc2   = "allow"
        domain       = "Network"
        cloudservice = "no_tier0_ec2"
    })

  }
  assume_role {
    role_arn = "arn:aws:iam::${local.network_shared_prod_account_id}:role/${local.aws_role_name}"

  }
}


provider "aws" {
  region = var.aws_region_secondary
  alias  = "west"

  default_tags {
    tags = merge(
      {
        dud          = "REPLACE_DUD"
        department   = "PlatformEngineering"
        managedby    = "Terraform"
        environment  = local.environment
        location     = "aws-us-west-2"
        accenture_ru = "n"
        owner        = "replace-owner"
        createdby    = "replace-createdby"
        project      = "ISE Deployment"
        nonGamiEc2   = "allow"
        domain       = "Network"
        cloudservice = "no_tier0_ec2"
    })

  }
  assume_role {
    role_arn = "arn:aws:iam::${local.network_shared_prod_account_id}:role/${local.aws_role_name}"

  }
}
