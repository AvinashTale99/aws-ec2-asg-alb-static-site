#!/bin/bash
yum update -y
yum install -y httpd git
systemctl start httpd
systemctl enable httpd
usermod -aG apache ec2-user
chmod 755 /var/www/html
cd /var/www/html
git clone https://github.com/AvinashTale99/ec2-static-website.git
cp -r aws-ec2-s3-static-website/* /var/www/html/
rm -rf aws-ec2-s3-static-website
echo "<h1>Hello from $(hostname -f) webserver</h1>" >> /var/www/html/index.html


