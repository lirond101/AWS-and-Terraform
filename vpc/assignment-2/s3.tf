module "web_app_s3" {
  source = "./modules/web-app-s3"

  bucket_name = lower("${var.s3_bucket_name}")
  common_tags = local.common_tags
}