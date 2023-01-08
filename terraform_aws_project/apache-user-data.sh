#!/bin/bash
sudo yum -y update 
sudo yum -y install httpd 
systemctl enable httpd
systemctl start httpd

echo "<html><body><div>Terraforming Mars soon!</div></body></html>" > /var/www/html/index.html
