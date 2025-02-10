locals {
  db_vpc_id            = data.aws_db_subnet_group.db.vpc_id
  db_subnet_ids        = data.aws_db_subnet_group.db.subnet_ids
  db_subnet_id_to_cidr = { for subnet in local.db_subnet_ids : subnet => data.aws_subnet.db[subnet].cidr_block }
  db_ip_address        = data.dns_a_record_set.db_address.addrs[0]
}

data "aws_db_instance" "db" {
  db_instance_identifier = var.db_instance_identifier
}

data "aws_db_subnet_group" "db" {
  name = data.aws_db_instance.db.db_subnet_group
}

data "aws_subnet" "db" {
  for_each = toset(data.aws_db_subnet_group.db.subnet_ids)
  vpc_id   = local.db_vpc_id
  id       = each.key
}

data "dns_a_record_set" "db_address" {
  host = data.aws_db_instance.db.address
}

module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = var.name

  load_balancer_type = "network"

  vpc_id  = var.vpc_id
  subnets = var.public_subnet_ids

  enable_deletion_protection = false

  default_port     = var.db_port
  default_protocol = "TCP"

  listeners = {
    db = {
      port     = var.db_port
      protocol = "TCP"
      forward = {
        target_group_key = "db"
      }
    }
  }

  target_groups = {
    db = {
      name_prefix = "db-"
      port        = var.db_port
      protocol    = "TCP"
      target_type = "ip"
      target_id   = local.db_ip_address
      health_check = {
        enabled  = true
        port     = "traffic-port"
        protocol = "TCP"
        interval = 10
      }
    }
  }

  security_groups = var.additional_security_group_ids

  security_group_ingress_rules = {
    for cidr in var.allowed_cidrs : cidr => {
      from_port   = var.db_port
      to_port     = var.db_port
      ip_protocol = "tcp"
      description = "Allow inbound traffic from ${cidr}"
      cidr_ipv4   = cidr
    }
  }
}
