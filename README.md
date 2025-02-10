# AWS RDS Reverse Proxy with NLB - Terraform AWS Module

This Terraform module creates a **Network Load Balancer (NLB)** that acts as a reverse proxy to an **AWS RDS** instance. It is particularly useful when you want to expose a database endpoint to clients (for example, an on-premises environment or developer workstations) without directly exposing the native RDS endpoint. Instead, traffic flows through a secure network load balancer.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture Diagram](#architecture-diagram)
- [Usage](#usage)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Examples](#examples)
- [License](#license)

---

## Overview

By default, an RDS instance is accessible only within a private subnet or via restricted public access (if configured). This module sets up:

- A **Network Load Balancer** in the specified public subnets.
- A **TCP** listener on the same port as your database (e.g., `5432` for PostgreSQL).
- A **Target Group** that forwards traffic to the RDS instance’s IP or DNS address.
- (Optionally) **Security Group Ingress Rules** that restrict inbound traffic to specific CIDRs you provide.

---

## Diagram

```
   [Allowed CIDRs]
         |
   (Internet traffic)
         |
   +-------------------------+
   |  Network Load Balancer |
   |    (public subnets)    |
   +----------+-------------+
              |
          (TCP 5432)
              |
    +-----------------------+
    |  RDS DB Instance     |
    |  (private subnets)   |
    +-----------------------+
```

1. **Inbound** traffic arrives on the NLB from specific CIDRs.  
2. NLB **forwards** traffic to the RDS instance using the DB’s endpoint (IP or DNS).  
3. Security Group rules **restrict** access to only the ports and CIDRs you specify.

---

## Usage

Below is a **basic** usage example. Refer to the [./examples](examples) for a more complete Terraform setup with a VPC, RDS instance, and this module.

```hcl
module "nlb_reverse_proxy" {
  source = "git::https://github.com/your-org/terraform-aws-nlb-reverse-proxy.git"

  name                          = "my-rds-reverse-proxy"
  public_subnet_ids             = ["subnet-0123456789abcdef0", "subnet-123456789abcdef01"]
  db_instance_identifier        = "my-postgres-db"
  allowed_cidrs                 = ["1.2.3.4/32", "10.0.0.0/16"]
  additional_security_group_ids = ["sg-0123456789abcdef0"]
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.62 |
| <a name="requirement_dns"></a> [dns](#requirement\_dns) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.62 |
| <a name="provider_dns"></a> [dns](#provider\_dns) | ~> 3.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nlb"></a> [nlb](#module\_nlb) | terraform-aws-modules/alb/aws | ~> 9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_instance) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [dns_a_record_set.db_address](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/data-sources/a_record_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_security_group_ids"></a> [additional\_security\_group\_ids](#input\_additional\_security\_group\_ids) | List of additional security group IDs to associate with the NLB | `list(string)` | n/a | yes |
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of CIDR blocks allowed to access the NLB on port 5432 | `list(string)` | n/a | yes |
| <a name="input_db_instance_identifier"></a> [db\_instance\_identifier](#input\_db\_instance\_identifier) | Identifier of the RDS instance to forward traffic to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the NLB | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs for the NLB | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the created Network Load Balancer |
| <a name="output_arn_suffix"></a> [arn\_suffix](#output\_arn\_suffix) | ARN suffix of the Network Load Balancer |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of the Network Load Balancer |
| <a name="output_id"></a> [id](#output\_id) | ID of the created Network Load Balancer |
| <a name="output_listener_rules"></a> [listener\_rules](#output\_listener\_rules) | Listener rules of the Network Load Balancer |
| <a name="output_listeners"></a> [listeners](#output\_listeners) | Listeners of the Network Load Balancer |
| <a name="output_route53_records"></a> [route53\_records](#output\_route53\_records) | Route53 records of the Network Load Balancer |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | Security group ARN of the Network Load Balancer |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group ID of the Network Load Balancer |
| <a name="output_target_groups"></a> [target\_groups](#output\_target\_groups) | Target groups of the Network Load Balancer |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Zone ID of the Network Load Balancer |
