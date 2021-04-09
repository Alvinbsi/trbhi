#!/bin/bash
sudo apt-get Update
sudo apt-get install docker.io 
sudo systemctl start docker.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "sysctl -w vm.max_map_count=262144" >> /etc/sysctl.conf
