variable "name" {
  type        = string
  description = "Name of the NLB"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the NLB will be created"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the NLB"
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the NLB on port 5432"
}

variable "db_instance_identifier" {
  type        = string
  description = "Identifier of the RDS instance to forward traffic to"
}

variable "db_port" {
  type        = number
  description = "Port of the RDS instance to forward traffic to"
}

variable "additional_security_group_ids" {
  type        = list(string)
  description = "List of additional security group IDs to associate with the NLB"
}
