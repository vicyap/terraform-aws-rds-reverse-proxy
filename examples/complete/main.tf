locals {
  uuid               = substr(random_uuid.uuid.result, 0, 4)
  name               = "test-rdsrevpxynlb-${local.uuid}"
  vpc_cidr           = "10.0.0.0/16"
  my_ip_address      = chomp(data.http.my_ip_address.response_body)
  my_ip_address_cidr = "${local.my_ip_address}/32"
  db_port            = 5432
}

resource "random_uuid" "uuid" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "http" "my_ip_address" {
  url = "http://icanhazip.com"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = [cidrsubnet(local.vpc_cidr, 8, 0), cidrsubnet(local.vpc_cidr, 8, 1), cidrsubnet(local.vpc_cidr, 8, 2)]
  public_subnets  = [cidrsubnet(local.vpc_cidr, 8, 3), cidrsubnet(local.vpc_cidr, 8, 4), cidrsubnet(local.vpc_cidr, 8, 5)]

  create_egress_only_igw = false
  enable_nat_gateway     = false
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = local.name

  instance_class    = "db.t3.micro"
  allocated_storage = 5

  engine         = "postgres"
  engine_version = "16.6"

  db_name  = "postgres"
  username = "postgres"
  port     = tostring(local.db_port)

  password                    = "password"
  manage_master_user_password = false

  vpc_security_group_ids = [module.security_group.security_group_id]

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  create_db_parameter_group = true
  family                    = "postgres16"

  create_db_option_group = true
  major_engine_version   = "16"

  skip_final_snapshot = true
  apply_immediately   = true
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Security group for NLB reverse proxy to RDS"
  vpc_id      = module.vpc.vpc_id

  ingress_with_self = [
    {
      from_port   = local.db_port
      to_port     = local.db_port
      protocol    = "tcp"
      description = "Allow inbound port traffic from self"
    }
  ]

  egress_with_self = [
    {
      from_port   = local.db_port
      to_port     = local.db_port
      protocol    = "tcp"
      description = "Allow outbound port traffic to self"
    }
  ]
}

module "nlb_reverse_proxy" {
  source = "../"

  name                          = local.name
  vpc_id                        = module.vpc.vpc_id
  public_subnet_ids             = module.vpc.public_subnets
  allowed_cidrs                 = [local.my_ip_address_cidr]
  db_instance_identifier        = module.rds.db_instance_identifier
  db_port                       = local.db_port
  additional_security_group_ids = [module.security_group.security_group_id]
}
