variable "name" {
  type        = string
  description = "Name of the NLB"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the NLB"
}

variable "db_instance_identifier" {
  type        = string
  description = "Identifier of the RDS instance to forward traffic to"
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the NLB on port 5432"
}

variable "additional_security_group_ids" {
  type        = list(string)
  description = "List of additional security group IDs to associate with the NLB"
}
