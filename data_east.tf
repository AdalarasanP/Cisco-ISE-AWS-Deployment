####################################################################################
#EAST CONFIG EC2 AND EBS
####################################################################################
# data "aws_ami" "cisco_ise_ami" {
#   provider    = aws.east
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["*Cisco Identity Services Engine (ISE) v3.3*"]
#   }

#   filter {
#     name   = "state"
#     values = ["available"]
#   }

# }

data "aws_ebs_default_kms_key" "current" {
  provider = aws.east
}

####################################################################################
#EAST CONFIG VPC and SUBNET
####################################################################################
data "aws_vpcs" "selected_vpc_east" {
  provider = aws.east
  tags = {
    Name = var.vpc_name_east
  }
}


data "aws_vpc" "selected_vpc_details_east" {
  provider = aws.east
  id       = data.aws_vpcs.selected_vpc_east.ids[0]
}

data "aws_subnet" "selected_subnet_east_1" {
  provider = aws.east
  vpc_id   = data.aws_vpc.selected_vpc_details_east.id

  filter {
    name   = "cidrBlock"
    values = [var.subnet_cidr_block_east_1]
  }
}

data "aws_subnet" "selected_subnet_east_2" {
  provider = aws.east
  vpc_id   = data.aws_vpc.selected_vpc_details_east.id

  filter {
    name   = "cidrBlock"
    values = [var.subnet_cidr_block_east_2]
  }
}

data "aws_subnet" "selected_subnet_east_3" {
  provider = aws.east
  vpc_id   = data.aws_vpc.selected_vpc_details_east.id

  filter {
    name   = "cidrBlock"
    values = [var.subnet_cidr_block_east_3]
  }
}

data "aws_subnet" "selected_subnet_east_5" {
  provider = aws.east
  vpc_id   = data.aws_vpc.selected_vpc_details_east.id

  filter {
    name   = "cidrBlock"
    values = [var.subnet_cidr_block_east_5]
  }
}

data "aws_subnet" "selected_subnet_east_6" {
  provider = aws.east
  vpc_id   = data.aws_vpc.selected_vpc_details_east.id

  filter {
    name   = "cidrBlock"
    values = [var.subnet_cidr_block_east_6]
  }
}
