output "vpc" {
  value = module.vpc
}

output "rds" {
  value = module.rds
}

output "nlb" {
  value = module.nlb_reverse_proxy
}

output "nlb_dns_name" {
  value = module.nlb_reverse_proxy.dns_name
}
