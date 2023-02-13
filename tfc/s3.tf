module "web_app_s3" {
  source = "https://github.com/lirond101/AWS-and-Terraform/tree/main/tfc/modules/terraform-aws-s3"

  bucket_name = lower("${var.s3_bucket_name}")
  common_tags = merge(local.common_tags, {
    Version = "1.0.0"
  })
}