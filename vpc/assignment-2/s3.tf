module "web_app_s3" {
  source = "./modules/web-app-s3"

  bucket_name             = var.s3_bucket_name
  elb_service_account_arn = data.aws_elb_service_account.root.arn
  common_tags             = local.common_tags
}

# resource "aws_s3_bucket_object" "object" {

#   bucket = module.web_app_s3.web_bucket.id
#   key    = "alb_logs"
#   source = ".${each.value}"

#   tags = local.common_tags
# }