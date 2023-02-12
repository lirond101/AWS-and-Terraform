output "web_bucket" {
  value = aws_s3_bucket.nginx_access_log
}

output "instance_profile" {
  value = aws_iam_instance_profile.instance_profile
}

