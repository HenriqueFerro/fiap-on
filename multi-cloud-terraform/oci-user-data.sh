#!/bin/bash
sudo yum install httpd -y
sudo apachectl start
sudo systemctl enable httpd
sudo apachectl configtest
sudo /bin/yum install firewalld -y
sudo /bin/firewall-offline-cmd --zone=public --add-service=http
sudo /bin/systemctl enable firewalld
sudo /bin/systemctl restart firewalld
sudo echo "<h1>MultiCloud Demo Oracle Cloud</h1>" | sudo tee /var/www/html/index.html