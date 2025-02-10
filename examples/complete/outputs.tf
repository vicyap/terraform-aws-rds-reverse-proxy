output "vpc" {
  value = module.vpc
}

output "rds" {
  value = module.rds
}

output "nlb" {
  value = module.nlb_reverse_proxy
}
