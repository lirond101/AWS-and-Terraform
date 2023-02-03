variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "ass1"
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.1.0.0/16"
}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets to create in VPC"
  default     = 2
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create in VPC"
  default     = 2
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "Opsschool"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}

variable "ubuntu_account_number" {
  default = "099720109477"
  type    = string
}

variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "availability_zone" {
  type = list(string)
}
 
variable "key_name" {
  type        = string
  description = "key variable for refrencing"
  default = "ec2Key"
}

variable "base_path" {
  type        = string
  description = "Base path for referencing"
  default = "/home/ec2-user/AWS-and-Terraform/vpc/assignment-1/"
}