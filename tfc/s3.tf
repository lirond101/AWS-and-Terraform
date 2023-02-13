module "web_app_s3" {
  source = "./modules/terraform-aws-s3"

  bucket_name = lower("${var.s3_bucket_name}")
  common_tags = merge(local.common_tags, {
    Version = "1.0.0"
  })
}