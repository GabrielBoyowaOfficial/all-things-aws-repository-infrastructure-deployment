#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
