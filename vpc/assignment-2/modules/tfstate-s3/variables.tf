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

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "opsschool"
}

variable "unique_id" {
  type        = string
  description = "Unique name for s3 bucket"
  default     = "04022023"
}

# variable "common_tags" {
#   type        = map(string)
#   description = "Map of tags to be applied to all resources"
#   default     =  merge(local.common_tags, {
#     Name = "${local.name_prefix}-vpc"
#   })
# }