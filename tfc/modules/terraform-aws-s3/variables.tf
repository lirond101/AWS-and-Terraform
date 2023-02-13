variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to create"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources"
  default     = {}
}