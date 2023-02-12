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

variable "nginx_root_disk_size" {
  description = "The size of the root disk"
  default     = 10
}

variable "nginx_encrypted_disk_size" {
  description = "The size of the secondary encrypted disk"
  default     = 10
}

variable "nginx_encrypted_disk_device_name" {
  description = "The name of the device of secondary encrypted disk"
  default     = "xvdh"
  type        = string
}

variable "volumes_type" {
  description = "The type of all the disk instances in my project"
  default     = "gp2"
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
  default     = "ec2Key2"
}

variable "base_path" {
  type        = string
  description = "Base path for referencing"
  default     = "/home/ec2-user/AWS-and-Terraform/vpc/assignment-2/"
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

variable "s3_bucket_name" {
  type = string
  description = "Name of the S3 bucket to create"
  default = "opsschool-lirondadon-nginx-access-log2"
}
