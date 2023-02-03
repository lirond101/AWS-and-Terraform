variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "vpc-assig"
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

variable "key_name" {
  type        = string
  description = "key variable for refrencing"
  default     = "ec2Key"
}

variable "base_path" {
  type        = string
  description = "Base path for referencing"
  default     = "/home/ec2-user/AWS-and-Terraform/vpc/assignment-1/"
}

variable "public_subnets" {
  type = list(string)
  description = "Desired public_subnets as list of strings"
}

variable "private_subnets" {
  type = list(string)
  description = "Desired private_subnets as list of strings"
}

variable "availability_zone" {
  type = list(string)
  description = "Desired AZs as list of strings"
}

