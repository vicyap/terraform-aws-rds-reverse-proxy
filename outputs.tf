output "id" {
  description = "ID of the created Network Load Balancer"
  value       = module.nlb.id
}

output "arn" {
  description = "ARN of the created Network Load Balancer"
  value       = module.nlb.arn
}

output "arn_suffix" {
  description = "ARN suffix of the Network Load Balancer"
  value       = module.nlb.arn_suffix
}

output "dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = module.nlb.dns_name
}

output "zone_id" {
  description = "Zone ID of the Network Load Balancer"
  value       = module.nlb.zone_id
}

output "listeners" {
  description = "Listeners of the Network Load Balancer"
  value       = module.nlb.listeners
}

output "listener_rules" {
  description = "Listener rules of the Network Load Balancer"
  value       = module.nlb.listener_rules
}

output "target_groups" {
  description = "Target groups of the Network Load Balancer"
  value       = module.nlb.target_groups
}

output "security_group_arn" {
  description = "Security group ARN of the Network Load Balancer"
  value       = module.nlb.security_group_arn
}

output "security_group_id" {
  description = "Security group ID of the Network Load Balancer"
  value       = module.nlb.security_group_id
}

output "route53_records" {
  description = "Route53 records of the Network Load Balancer"
  value       = module.nlb.route53_records
}
