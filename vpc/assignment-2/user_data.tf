locals {
  my-instance-userdata = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Whiskey Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\">Welcome to Grandpa's Whiskey</span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF
}